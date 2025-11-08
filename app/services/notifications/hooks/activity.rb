module Notifications
  module Hooks
    module Activity
      extend Notifications::HookHelpers

      def self.activity_calendar_(activity, action)
        calendar = activity.calendar
        data = calendar_activity_data(activity)

        schedule_calendar_notifications(calendar, action, data)
      end

      def self.daily_deadline_notifications
        [7, 3, 1, 0].each do |days_before|
          target_date = Date.current + days_before
          range = target_date.beginning_of_day.in_time_zone..target_date.end_of_day.in_time_zone

          ::Activity.where(final_date: range).find_each do |activity|
            schedule_deadline_notifications_for_activity(activity, days_before)
          end
        end
      end

      private_class_method def self.calendar_activity_data(activity)
        calendar = activity.calendar
        {
          activity_name: activity.name,
          tcc_type: I18n.t("enums.tcc.#{activity.tcc}"),
          year: calendar.year,
          semester: I18n.t("enums.semester.#{calendar.semester}"),
          created_at: activity.created_at.strftime('%d/%m/%Y %H:%M'),
          updated_at: activity.updated_at.strftime('%d/%m/%Y %H:%M')
        }
      end

      private_class_method def self.deadline_notification_data(activity, days_before)
        {
          activity_title: activity.name,
          tcc: I18n.t("enums.tcc.#{activity.tcc}"),
          final_date: activity.final_date,
          days_left: days_before
        }
      end

      private_class_method def self.schedule_deadline_notifications_for_activity(activity,
                                                                                 days_before)
        activity.calendar.orientations.each do |orientation|
          recipients_for_orientation(orientation).each do |recipient|
            schedule_single_deadline_notification(activity, recipient, days_before)
          end
        end
      end

      private_class_method def self.schedule_single_deadline_notification(activity, recipient,
                                                                          days_before)
        class_name = class_name_lower(recipient)

        data = deadline_notification_data(activity, days_before)

        ek = event_key('activity', activity.id, 'deadline', days_before, 'final_date',
                       activity.final_date, 'user', class_name, recipient.id)

        schedule_notification(
          notification_type: "#{class_name}_deadline_upcoming",
          recipient: recipient,
          data: data,
          event_key: ek
        )
      end

      private_class_method def self.schedule_calendar_notifications(calendar, action, data)
        calendar.orientations.each do |orientation|
          recipients_for_orientation(orientation).each do |recipient|
            ek = event_key('activity_calendar', calendar.id, action, 'user', recipient.class.name,
                           recipient.id)

            schedule_notification(
              notification_type: "activity_calendar_#{action}",
              recipient: recipient, data: data, event_key: ek
            )
          end
        end
      end

      private_class_method def self.recipients_for_orientation(orientation)
        ([orientation.academic] + [orientation.advisor]).uniq
      end
    end
  end
end

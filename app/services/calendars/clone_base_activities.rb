module Calendars
  class CloneBaseActivities
    private_class_method :new

    def self.to(calendar)
      new(calendar).clone
    end

    def initialize(calendar)
      @calendar = calendar
    end

    def clone
      base_activities = BaseActivity.where(tcc: @calendar.tcc)

      base_activities.each do |base_activity|
        initial_date = initial_date_to(base_activity)
        final_date = final_date_to(base_activity, initial_date)

        create_activity(base_activity, initial_date, final_date)
      end
    end

    private

    def create_activity(base_activity, initial_date, final_date)
      selected_attributes = %w[name tcc judgment identifier final_version base_activity_type_id]

      activity_params = base_activity.attributes.slice(*selected_attributes)
      activity_params[:calendar_id] = @calendar.id
      activity_params[:initial_date] = initial_date
      activity_params[:final_date] = final_date

      @calendar.activities.create!(activity_params)
    end

    def initial_date_to(base_activity)
      beginning_of_semester + base_activity.days_to_start.days
    end

    def final_date_to(base_activity, initial_date)
      initial_date + base_activity.duration_in_days.days + 23.hours + 59.minutes
    end

    def beginning_of_semester
      month = Calendar.current_semester == 'one' ? 'mar' : 'aug'
      Time.zone.parse("#{month} 01 00:00:00 #{Calendar.current_year}")
    end
  end
end

module Notifications
  module ExaminationBoards
    class Templates
      TITLES = {
        'scheduled' => 'Banca agendada',
        'updated' => 'Agendamento da banca atualizado',
        'assigned' => 'Designação para banca de avaliação',
        'removed' => 'Remoção da banca de avaliação',
        'cancelled' => 'Agendamento da banca cancelado'
      }.freeze

      def self.install!
        TITLES.each do |event, title|
          template = NotificationTemplate.find_or_initialize_by(key: "examination_board_#{event}")
          template.assign_attributes(title: title, subject: title, channel: 'email', active: true,
                                     body: body(event, title))
          template.save!
          configure_rule(template)
        end
        retire_legacy_templates
      end

      def self.retire_legacy_templates
        NotificationTemplate.where(key: Validity::LEGACY_TYPES).find_each do |template|
          template.update!(active: false)
        end
        Notification.where(notification_type: Validity::LEGACY_TYPES,
                           status: %w[pending scheduled]).find_each do |notification|
          notification.update!(status: 'cancelled')
        end
      end

      def self.configure_rule(template)
        rule = template.notification_rule || template.build_notification_rule
        rule.update!(days_before: 0, hours_before: 0, hours_after: 0,
                     max_retries: 1, retry_interval_hours: 0, extra_notes: 'Envio único')
      end

      def self.body(event, title)
        text = "#{title}.<br>Aluno: %<academic_name>s<br>Trabalho: %<orientation_title>s"
        return "#{text}<br>Você não integra mais esta banca." if event == 'removed'
        return "#{text}<br>O agendamento foi cancelado." if event == 'cancelled'

        text += '<br>Data: %<date>s<br>Horário: %<time>s<br>Local: %<place>s'
        if event == 'updated'
          text += '<br>Participantes incluídos: %<added_members>s' \
                  '<br>Participantes removidos: %<removed_members>s'
        end
        text
      end
    end
  end
end

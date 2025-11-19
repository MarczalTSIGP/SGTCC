# app/models/concerns/current_calendar.rb (ou onde estiver definido)
require 'active_support/concern'

module CurrentCalendar
  extend ActiveSupport::Concern

  included do
    def self.current_year
      Time.zone.now.year
    end

    def self.current_month
      Time.zone.now.month
    end

    # Se não houver, pega o último calendário e usa seu semester.
    def self.current_semester
      calendar = where("start_date <= ? AND end_date >= ?", Date.current, Date.current).first

      if calendar.present?
        # normalizamos para string minuscula e comparamos.
        sem = calendar.semester.to_s.downcase
        return 2 if sem == 'two' || sem == '2'
        return 1
      end

      last_calendar = order(year: :desc, semester: :desc).first
      if last_calendar.present?
        sem = last_calendar.semester.to_s.downcase
        return 2 if sem == 'two' || sem == '2'
        return 1
      end

      current_month <= 7 ? 1 : 2
    end

    def self.current_by_tcc_one
      where(tcc: tccs[:one])
        .where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
        .order(year: :desc, semester: :desc)
        .first ||
      where(tcc: tccs[:one]).order(end_date: :desc).first
    end

    def self.current_by_tcc_two
      where(tcc: tccs[:two])
        .where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
        .order(year: :desc, semester: :desc)
        .first ||
      where(tcc: tccs[:two]).order(end_date: :desc).first
    end

    def self.current_by_tcc_one?(calendar)
      calendar&.id == current_by_tcc_one&.id
    end

    def self.current_by_tcc_two?(calendar)
      calendar&.id == current_by_tcc_two&.id
    end

    def self.current_calendar?(calendar)
      current_by_tcc_one?(calendar) || current_by_tcc_two?(calendar)
    end
  end
end

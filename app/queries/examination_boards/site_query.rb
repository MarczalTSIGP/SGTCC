module ExaminationBoards
  class SiteQuery
    def self.call(relation = ExaminationBoard.all)
      new(relation).call
    end

    def initialize(relation)
      @relation = relation
    end

    def call
      current_cal = current_calendar_for_site
      return [] unless current_cal

      upcoming_from_now(current_cal) + past_until_now(current_cal)
    end

    private

    attr_reader :relation

    def current_calendar_for_site
      Calendar.where('? BETWEEN start_date AND end_date', Date.current).first ||
        Calendar.order(year: :desc, semester: :desc).first
    end

    def base_scope_for_calendar(current_calendar)
      period = current_calendar.start_date.beginning_of_day..current_calendar.end_date.end_of_day
      relation.joins(orientation: :calendars).distinct.where(date: period)
    end

    def upcoming_from_now(current_calendar)
      base_scope_for_calendar(current_calendar)
        .where(date: Time.current..)
        .order(date: :asc)
        .site_with_relationships
        .to_a
    end

    def past_until_now(current_calendar)
      base_scope_for_calendar(current_calendar)
        .where(date: current_calendar.start_date.beginning_of_day...Time.current)
        .order(date: :desc)
        .site_with_relationships
        .to_a
    end
  end
end

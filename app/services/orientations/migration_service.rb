module Orientations
  class MigrationService
    Result = Struct.new(:migrated, :reason, keyword_init: true)

    def self.call(orientation)
      new(orientation).call
    end

    def initialize(orientation)
      @orientation = orientation
    end

    def call
      return Result.new(migrated: false, reason: :wrong_status) unless approved_tcc_one?
      return Result.new(migrated: false, reason: :already_migrated) if already_migrated?

      new_calendar = Calendar.next_semester_tcc_two(@orientation.current_calendar)
      return Result.new(migrated: false, reason: :no_next_calendar) if new_calendar.nil?

      unless @orientation.update(calendar_ids: @orientation.calendar_ids << new_calendar.id)
        return Result.new(migrated: false, reason: :update_failed)
      end

      Result.new(migrated: true, reason: nil)
    end

    private

    def approved_tcc_one?
      @orientation.equal_status?('APPROVED_TCC_ONE')
    end

    def already_migrated?
      @orientation.calendars.exists?(tcc: :one) && @orientation.calendars.exists?(tcc: :two)
    end
  end
end

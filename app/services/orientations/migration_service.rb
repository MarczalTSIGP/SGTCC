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

      new_calendar = Calendar.next_semester_tcc_two(@orientation.current_calendar)
      return Result.new(migrated: false, reason: :no_next_calendar) if new_calendar.nil?

      @orientation.update(calendar_ids: @orientation.calendar_ids << new_calendar.id)
      Result.new(migrated: true, reason: nil)
    end

    private

    def approved_tcc_one?
      @orientation.equal_status?('APPROVED_TCC_ONE')
    end
  end
end

class AddStartDateEndDateToCalendar < ActiveRecord::Migration[7.2]
  CALENDARS_DATA = [
    { id: 2, start_date: '2019-08-12', end_date: '2019-12-19' },
    { id: 4, start_date: '2019-08-12', end_date: '2019-12-19' },
    { id: 5, start_date: '2020-03-02', end_date: '2020-07-14' },
    { id: 6, start_date: '2020-03-02', end_date: '2020-07-14' },
    { id: 7, start_date: '2021-02-18', end_date: '2020-05-25' },
    { id: 8, start_date: '2021-02-18', end_date: '2020-05-25' },
    { id: 9, start_date: '2021-06-15', end_date: '2021-09-04' },
    { id: 10, start_date: '2021-06-15', end_date: '2021-09-04' },
    { id: 11, start_date: '2018-08-06', end_date: '2018-12-14' },
    { id: 12, start_date: '2019-03-11', end_date: '2019-07-18' },
    { id: 13, start_date: '2021-09-23', end_date: '2021-12-20' },
    { id: 14, start_date: '2021-09-23', end_date: '2021-12-20' },
    { id: 15, start_date: '2016-08-08', end_date: '2016-12-13' },
    { id: 16, start_date: '2017-03-02', end_date: '2017-07-07' },
    { id: 17, start_date: '2017-08-07', end_date: '2017-12-15' },
    { id: 18, start_date: '2022-03-03', end_date: '2022-07-06' },
    { id: 19, start_date: '2022-03-03', end_date: '2022-07-06' },
    { id: 20, start_date: '2017-03-02', end_date: '2017-07-07' },
    { id: 21, start_date: '2018-03-05', end_date: '2018-07-09' },
    { id: 22, start_date: '2018-08-06', end_date: '2018-12-14' },
    { id: 23, start_date: '2019-03-11', end_date: '2019-07-18' },
    { id: 24, start_date: '2022-08-11', end_date: '2022-12-21' },
    { id: 25, start_date: '2022-08-11', end_date: '2022-12-21' },
    { id: 26, start_date: '2023-03-02', end_date: '2023-07-08' },
    { id: 27, start_date: '2023-03-02', end_date: '2023-07-08' },
    { id: 28, start_date: '2023-08-09', end_date: '2023-12-20' },
    { id: 29, start_date: '2023-08-09', end_date: '2023-12-20' },
    { id: 30, start_date: '2024-03-04', end_date: '2024-09-14' },
    { id: 31, start_date: '2024-03-04', end_date: '2024-09-14' },
    { id: 32, start_date: '2024-10-01', end_date: '2025-02-28' },
    { id: 33, start_date: '2024-10-01', end_date: '2025-02-28' },
    { id: 34, start_date: '2025-03-25', end_date: '2025-07-11' },
    { id: 35, start_date: '2025-03-25', end_date: '2025-07-11' },
    { id: 36, start_date: '2025-08-12', end_date: '2025-12-19' },
    { id: 37, start_date: '2025-08-12', end_date: '2025-12-19' },
    { id: 38, start_date: '2013-03-04', end_date: '2013-07-06' },
    { id: 39, start_date: '2013-03-04', end_date: '2013-07-06' },
    { id: 40, start_date: '2013-08-05', end_date: '2013-12-06' },
    { id: 41, start_date: '2013-08-05', end_date: '2013-12-06' },
    { id: 42, start_date: '2014-03-15', end_date: '2014-07-31' },
    { id: 43, start_date: '2014-03-15', end_date: '2014-07-31' },
    { id: 44, start_date: '2014-08-15', end_date: '2014-12-20' },
    { id: 45, start_date: '2014-08-15', end_date: '2014-12-20' },
    { id: 46, start_date: '2015-02-23', end_date: '2015-07-03' },
    { id: 47, start_date: '2015-02-23', end_date: '2015-07-03' },
    { id: 48, start_date: '2015-08-10', end_date: '2015-12-10' },
    { id: 49, start_date: '2015-08-10', end_date: '2015-12-10' },
    { id: 50, start_date: '2016-02-29', end_date: '2016-06-23' },
    { id: 51, start_date: '2016-02-29', end_date: '2016-06-23' },
    { id: 52, start_date: '2016-08-08', end_date: '2016-12-13' },
    { id: 53, start_date: '2017-08-07', end_date: '2017-12-15' }
  ].freeze

  def change
    add_date_columns
    backfill_calendar_dates
  end

  private

  def add_date_columns
    add_column :calendars, :start_date, :datetime, null: true unless column_exists?(:calendars,
                                                                                    :start_date)
    add_column :calendars, :end_date, :datetime, null: true unless column_exists?(:calendars,
                                                                                  :end_date)
  end

  def backfill_calendar_dates
    calendar_model = migration_calendar_model

    CALENDARS_DATA.each do |data|
      calendar = calendar_model.find_by(id: data[:id])
      next unless calendar

      calendar.update!(start_date: data[:start_date], end_date: data[:end_date])
    end
  end

  def migration_calendar_model
    @migration_calendar_model ||= Class.new(ActiveRecord::Base) do
      self.table_name = 'calendars'
    end
  end
end

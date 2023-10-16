class DateCalculator

  def self.calculate_all_dates(tcc)
    interval = calculate_interval(tcc)
    initial_date = calculate_initial_date
    final_date = calculate_final_date(initial_date, interval)

    { initial_date: initial_date, final_date: final_date, interval: interval }
  end

  def self.calculate_interval(tcc)
    tcc == 1 ? 10.days : 30.days
  end

  def self.calculate_initial_date
    month = Cal endar.current_semester == 'one' ? 'mar' : 'aug'
    Time.zone.parse("#{month} 01 00:00:00 #{Cal endar.current_year}")
  end

  def self.calculate_final_date(initial_date, interval)
    initial_date + interval + 23.hours + 59.minutes
  end

  def self.increment_date(date, days)
    date + days.days
  end
end

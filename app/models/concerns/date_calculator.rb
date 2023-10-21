require 'active_support/concern'

module DateCalculator
  extend ActiveSupport::Concern

  def self.calculate_initial_date
    month = Calendar.current_semester == 'one' ? 'mar' : 'aug'
    Time.zone.parse("#{month} 09 00:00:00 #{Calendar.current_year}")
  end

  def self.calculate_final_date(initial_date, interval)
    initial_date + interval + 23.hours + 59.minutes
  end

  def self.increment_date(days)
    initial_date = calculate_initial_date
    initial_date + days
  end
end

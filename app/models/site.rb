class Site < ApplicationRecord
  validates :title, presence: true

  def self.select_calendar_years
    Calendar.select(:year).distinct.order(year: :desc).pluck(:year)
  end
end

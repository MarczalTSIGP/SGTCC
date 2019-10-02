class Activity < ApplicationRecord
  include ActivityIdentifier
  include Tcc

  belongs_to :base_activity_type
  belongs_to :calendar, required: false

  validates :name, presence: true
  validates :tcc, presence: true
  validates :initial_date, presence: true
  validates :final_date, presence: true
  validates :identifier, presence: true

  scope :recent, -> { order(:final_date) }

  def deadline
    I18n.t('time.deadline',
           initial_date: I18n.l(initial_date, format: :datetime),
           final_date: I18n.l(final_date, format: :datetime))
  end

  def status
    return :ontime if final_date.to_date == Date.current
    return :expired if final_date < Time.zone.now

    :in_the_future
  end
end

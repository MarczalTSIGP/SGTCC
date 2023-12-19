class Activity < ApplicationRecord
  include TccIdentifier
  include Tcc

  belongs_to :base_activity_type
  belongs_to :calendar, optional: true

  has_many :academic_activities, dependent: :destroy
  has_many :academics, through: :academic_activities

  validates :name, presence: true
  validates :tcc, presence: true
  validates :initial_date, presence: true
  validates :final_date, presence: true

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

  # Academics and responses
  def responses
    Logics::Activity::Responses.new(self)
  end

  def academic_activity(orientation)
    AcademicActivity.find_by(activity: id, academic: orientation.academic)
  end

  def find_academic_activity_by_academic(academic)
    academic_activities.find_by(academic: academic)
  end

  def identifier_translated
    I18n.t("enums.activity.identifiers.#{identifier}")
  end

  def open?(current_time: Time.current)
    current_time >= initial_date && current_time <= final_date
  end

  def expired?
    Time.current > final_date
  end
end

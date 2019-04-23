class Activity < ApplicationRecord
  include Tcc

  belongs_to :base_activity_type
  belongs_to :calendar, required: false

  validates :name, presence: true
  validates :tcc, presence: true

  def self.by_tcc(tcc = Activity.tccs[:one], calendar_id)
    Activity.where(tcc: tcc, calendar_id: calendar_id)
            .includes(:base_activity_type)
            .order(:name)
  end
end

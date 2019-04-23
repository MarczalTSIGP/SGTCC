class Activity < ApplicationRecord
  include Tcc

  belongs_to :base_activity_type
  belongs_to :calendar, required: false

  validates :name, presence: true
  validates :tcc, presence: true
  validates :initial_date, presence: true
  validates :final_date, presence: true
end

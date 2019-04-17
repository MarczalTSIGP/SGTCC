class Activity < ApplicationRecord
  include Tcc

  belongs_to :base_activity_type

  validates :name, presence: true
  validates :tcc, presence: true
end

class BaseActivityType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :base_activities, dependent: :destroy

  validates :identifier, presence: true

  enum identifier: {
    send_document: 'send_document',
    info: 'info'
  }
end

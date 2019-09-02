class Site < ApplicationRecord
  validates :title, presence: true
end

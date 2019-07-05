class SignatureCode < ApplicationRecord
  validates :code, presence: true, uniqueness: { case_sensetive: false }

  has_many :signatures, dependent: :destroy
end

class SignatureCode < ApplicationRecord
  validates :code, presence: true, uniqueness: { case_sensetive: false }

  has_one :document, dependent: :destroy
end

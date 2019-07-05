class SignatureCode < ApplicationRecord
  validates :code, presence: true, uniqueness: { case_sensetive: false }
end

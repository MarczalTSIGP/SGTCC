class SignatureCode < ApplicationRecord
  validates :code, presence: true, uniqueness: { case_sensetive: false }

  has_many :signatures, dependent: :destroy

  def all_signed?
    signatures.where(status: true).count == signatures.count
  end
end

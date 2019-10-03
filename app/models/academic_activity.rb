class AcademicActivity < ApplicationRecord
  belongs_to :academic
  belongs_to :activity

  mount_uploader :pdf, PdfUploader
  mount_uploader :complementary_files, ZipUploader

  validates :title, presence: true
  validates :summary, presence: true
  validates :pdf, presence: true

  def update_judgment
    update(judgment: true)
  end
end

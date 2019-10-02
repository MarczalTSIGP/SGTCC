class AcademicActivity < ApplicationRecord
  belongs_to :academic
  belongs_to :activity

  mount_uploader :pdf, PdfUploader
  mount_uploader :complementary_files, ZipUploader
end

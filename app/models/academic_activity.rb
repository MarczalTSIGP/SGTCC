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

  def academic_filename
    academic = I18n.transliterate(self.academic.name.tr(' ', '_'))
    calendar = activity.calendar.year_with_semester.tr('/', '_')
    "GP_COINT_#{calendar}_#{academic}".upcase
  end

  def pdf_filename
    "#{academic_filename}_#{activity.identifier_translated}".upcase
  end

  def complementary_files_filename
    "#{academic_filename}_AC_#{activity.identifier_translated}".upcase
  end
end

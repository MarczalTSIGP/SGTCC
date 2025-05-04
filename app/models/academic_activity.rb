class AcademicActivity < ApplicationRecord
  belongs_to :academic
  belongs_to :activity

  mount_uploader :pdf, PdfUploader
  mount_uploader :complementary_files, ZipUploader

  validates :title, presence: true
  validates :summary, presence: true
  validates :pdf, presence: true

  after_commit :clear_examination_boards_cache

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

  # TODO: Refactor and write tests for this method
  def clear_examination_boards_cache
    return unless academic.current_orientation

    academic.current_orientation.examination_boards.each do |examination_board|
      # rubocop:disable Rails/SkipsModelValidations
      examination_board.touch if examination_board.academic_activity == self
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end

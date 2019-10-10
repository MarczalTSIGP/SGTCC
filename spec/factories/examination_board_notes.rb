FactoryBot.define do
  factory :examination_board_note do
    note { rand(1..100) }
    appointment_file { File.open(FileSpecHelper.pdf.path) }
    examination_board
    professor
  end
end

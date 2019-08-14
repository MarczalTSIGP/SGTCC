FactoryBot.define do
  factory :examination_board_attendee do
    examination_board
    professor
    external_member
  end
end

require 'rails_helper'

RSpec.describe ExaminationBoardAttendee do
  describe 'associations' do
    it { is_expected.to belong_to(:examination_board) }
    it { is_expected.to belong_to(:professor).optional }
    it { is_expected.to belong_to(:external_member).optional }
  end
end

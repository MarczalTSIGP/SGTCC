require 'rails_helper'

RSpec.describe ExaminationBoardNotePolicy do
  subject(:policy) { described_class.new(professor, examination_board) }

  let(:professor) { create(:professor) }
  let(:examination_board) { create(:examination_board, :proposal) }

  it 'allows editing before the defense minutes' do
    expect(policy.edit?).to be(true)
  end

  it 'denies editing after the defense minutes' do
    create(:document_type_adpp)
    examination_board.create_defense_minutes

    expect(policy.edit?).to be(false)
  end
end

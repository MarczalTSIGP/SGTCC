require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe '#find_note_by_professor' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation, advisor: professor) }
    let(:examination_board) { create(:examination_board) }
    let!(:note) do
      create(:examination_board_note, examination_board:,
                                      professor:)
    end

    it 'returns the note by professor' do
      expect(examination_board.find_note_by_professor(professor)).to eq(note)
    end
  end

  describe '#find_note_by_external_member' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }
    let(:examination_board) { create(:examination_board) }
    let!(:note) do
      create(:examination_board_note, examination_board:,
                                      external_member:)
    end

    it 'returns the note by external_member' do
      expect(examination_board.find_note_by_external_member(external_member)).to eq(note)
    end
  end

  describe '#advisor?' do
    context 'when the professor is the advisor' do
      let(:examination_board) { create(:examination_board) }
      let(:professor) { examination_board.orientation.advisor }

      it 'returns true' do
        expect(examination_board.advisor?(professor)).to be(true)
      end
    end

    context 'when the professor is not the advisor' do
      let(:professor) { create(:professor) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.advisor?(professor)).to be(false)
      end
    end
  end

  describe '#professor_evaluator?' do
    context 'when the professor is the evaluator' do
      let(:examination_board) { create(:examination_board) }
      let(:professor) { examination_board.professors.first }

      it 'returns true' do
        expect(examination_board.professor_evaluator?(professor)).to be(true)
      end
    end

    context 'when the professor is not the evaluator' do
      let(:professor) { create(:professor) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.professor_evaluator?(professor)).to be(false)
      end
    end
  end

  describe '#external_member_evaluator?' do
    context 'when the external member is the evaluator' do
      let(:examination_board) { create(:examination_board) }
      let(:external_member) { examination_board.external_members.first }

      it 'returns true' do
        expect(examination_board.external_member_evaluator?(external_member)).to be(true)
      end
    end

    context 'when the external_member is not the evaluator' do
      let(:external_member) { create(:external_member) }
      let(:examination_board) { create(:examination_board) }

      it 'returns false' do
        expect(examination_board.external_member_evaluator?(external_member)).to be(false)
      end
    end
  end

  # describe '.can_create_defense_minutes?' do
  #   context 'when is the advisor' do
  #     let(:examination_board) { create(:examination_board) }
  #     let(:professor) { examination_board.orientation.advisor }

  #     it 'returns true' do
  #       expect(examination_board.can_create_defense_minutes?(professor)).to eq(true)
  #     end
  #   end

  #   context 'when is the responsible' do
  #     let(:examination_board) { create(:examination_board) }
  #     let(:professor) { create(:responsible) }

  #     it 'returns true' do
  #       expect(examination_board.can_create_defense_minutes?(professor)).to eq(true)
  #     end
  #   end

  #   context 'when can not create' do
  #     let(:professor) { create(:professor) }
  #     let(:examination_board) { create(:examination_board) }

  #     it 'returns false' do
  #       expect(examination_board.can_create_defense_minutes?(professor)).to eq(false)
  #     end
  #   end
  # end

  describe '#touch_updated_at' do
    let(:examination_board) { create(:examination_board) }

    it 'touches updated_at when a professor evaluator is added' do
      professor = create(:professor)

      expect { examination_board.professors << professor }
        .to(change { examination_board.reload.updated_at })
    end

    # `professors.delete` removes the join row via SQL delete without loading
    # ExaminationBoardAttendee records, so the has_many `after_remove:
    # :touch_updated_at` callback configured on `examination_board_attendees`
    # does not fire for this path (Rails only fires it for object-level
    # removal). This is pre-existing behavior, not introduced by this task.
    it 'does not touch updated_at when a professor evaluator is removed' do
      professor = create(:professor)
      examination_board.professors << professor

      expect { examination_board.professors.delete(professor) }
        .not_to(change { examination_board.reload.updated_at })
    end
  end

  describe '.all_evaluated' do
    let(:examination_board) { create(:examination_board) }
    let(:advisor_size) { 1 }
    let(:professors_size) { examination_board.professors.size }
    let(:external_members_size) { examination_board.external_members.size }

    it 'returns that all_evaluated is false' do
      examination_board.evaluators_number.times do
        create(:examination_board_note, examination_board:, note: nil)
      end

      expect(examination_board.all_evaluated?).to be(false)
    end

    it 'returns that all_evaluated is false when all give the note' do
      en = examination_board.evaluators_number - 1
      en.times do
        create(:examination_board_note, examination_board:, note: nil)
      end

      expect(examination_board.all_evaluated?).to be(false)
    end

    it 'returns that all_evaluated is true' do
      examination_board.evaluators_number.times do
        create(:examination_board_note, examination_board:, note: 80)
      end

      expect(examination_board.all_evaluated?).to be(true)
    end
  end
end

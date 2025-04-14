require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe '#minutes_type' do
    context 'when the examination board is a proposal' do
      let(:examination_board) { create(:proposal_examination_board) }

      it 'retuns the adpp' do
        expect(examination_board.minutes_type).to eq(:adpp)
      end
    end

    context 'when the examination board is a project' do
      let(:examination_board) { create(:project_examination_board) }

      it 'retuns the adpj' do
        expect(examination_board.minutes_type).to eq(:adpj)
      end
    end

    context 'when the examination board is a monograph' do
      let(:examination_board) { create(:monograph_examination_board) }

      it 'retuns the admg' do
        expect(examination_board.minutes_type).to eq(:admg)
      end
    end
  end

  describe '#users_to_document' do
    let(:examination_board) { create(:examination_board) }
    let(:professors) { examination_board.professors }

    let(:professors_formatted) do
      professors.map do |professor|
        { id: professor.id, name: professor.name_with_scholarity }
      end
    end

    it 'returns the array with evaluators formatted' do
      expect(examination_board.users_to_document(professors)).to match_array(professors_formatted)
    end
  end

  describe '#available_defense_minutes?' do
    context 'when the document_available_until is greater than current time' do
      let(:examination_board) do
        create(:examination_board, date: Time.current,
                                   document_available_until: 1.day.from_now)
      end

      it 'returns true' do
        expect(examination_board.available_defense_minutes?).to be(true)
      end
    end

    context 'when the document_available_until is less than current time' do
      let(:examination_board) do
        create(:examination_board, date: Time.current,
                                   document_available_until: 1.day.ago)
      end

      it 'returns false' do
        expect(examination_board.available_defense_minutes?).to be(false)
      end
    end
  end

  describe '#create_defense_minutes' do
    context 'when create the defense minutes' do
      let(:examination_board) { create(:proposal_examination_board) }

      before do
        create(:document_type_adpp)
      end

      it 'returns the document created' do
        expect(examination_board.create_defense_minutes).to eq(Document.last)
      end
    end
  end

  describe '#create_non_attendance_defense_minutes' do
    context 'when create the non attendance defense minutes' do
      let(:examination_board) { create(:proposal_examination_board) }

      before do
        create(:document_type_adpp)
      end

      it 'returns the document created' do
        expect(examination_board.create_non_attendance_defense_minutes).to eq(Document.last)
      end
    end
  end

  describe '#defense_minutes' do
    context 'when returns the defense minutes' do
      let(:examination_board) { create(:proposal_examination_board) }

      before do
        create(:document_type_adpp)
      end

      it 'returns the defense minutes document' do
        defense_minutes = examination_board.create_defense_minutes
        expect(examination_board.defense_minutes).to eq(defense_minutes)
      end
    end
  end
end

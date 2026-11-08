require 'rails_helper'

RSpec.describe ExaminationBoards::EvaluatorsResponsesPresenter do
  subject(:presenter) { described_class.new(examination_board) }

  let(:examination_board) { create(:examination_board) }
  let(:professor) { create(:professor) }
  let(:external_member) { create(:external_member) }

  def advisor
    examination_board.orientation.advisor
  end

  def expected_evaluators
    examination_board.professors.to_a + examination_board.external_members.to_a + [advisor]
  end

  def response_for(evaluator)
    presenter.responses.find { |response| response.evaluator == evaluator }
  end

  before do
    examination_board.professors << professor
    examination_board.external_members << external_member
    examination_board.reload
  end

  describe '#responses' do
    it 'lists professors, then external members, then the advisor' do
      expect(presenter.responses.map(&:evaluator)).to eq(expected_evaluators)
    end

    it 'identifies each response by board and evaluator' do
      expect(presenter.responses.map(&:id))
        .to eq(expected_evaluators.map { |e| "#{examination_board.id}-#{e.id}" })
    end
  end

  context 'when a professor sent the note and appointments' do
    let(:response) { response_for(professor) }

    before do
      create(:examination_board_note, examination_board:, professor:,
                                      note: 80, appointment_text: '### ok')
    end

    it 'reports the note as sent' do
      expect(response.sent_note?).to be(true)
    end

    it 'exposes the appointment file' do
      expect(response.appointments_file?).to be(true)
      expect(response.appointments_file).to be_present
    end

    it 'exposes the appointment text' do
      expect(response.appointments_text?).to be(true)
      expect(response.appointments_text).to eq('### ok')
    end
  end

  context 'when an external member sent only the appointment text' do
    let(:response) { response_for(external_member) }

    before do
      create(:examination_board_note, examination_board:, professor: nil, external_member:,
                                      note: nil, appointment_file: nil, appointment_text: 'texto')
    end

    it 'finds the note by external member' do
      expect([response.sent_note?, response.appointments_file?, response.appointments_text?])
        .to eq([false, false, true])
    end
  end

  context 'when the evaluator has no note' do
    it 'reports nothing sent' do
      response = response_for(advisor)

      expect([response.sent_note?, response.appointments_file?, response.appointments_text?])
        .to eq([false, false, false])
    end
  end
end

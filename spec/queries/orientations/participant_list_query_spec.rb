require 'rails_helper'

RSpec.describe Orientations::ParticipantListQuery do
  describe '.call' do
    def query(relation:, segment:, profile:, **)
      described_class.call(relation:, segment:, profile:, **)
    end

    it 'lists professor orientations from an authorized relation only' do
      professor = create(:professor)
      other_professor = create(:professor)
      orientation = create(:orientation, :current, :tcc_one, advisor: professor)
      create(:orientation, :current, :tcc_one, advisor: other_professor)

      result = query(relation: professor.orientations, segment: :tcc_one,
                     profile: :professor_orientation)

      expect(result).to contain_exactly(orientation)
    end

    it 'keeps professor supervision status, search and history ordering' do
      professor = create(:professor)
      older_calendar = create(:calendar, :tcc_one, year: '2101', semester: :one)
      newer_calendar = create(:calendar, :tcc_two, year: '2102', semester: :two)
      older = create(:orientation, title: 'Projeto Alfa', status: 'APPROVED',
                                   calendars: [older_calendar], professor_supervisors: [professor])
      newer = create(:orientation, title: 'Projeto Alfa', status: 'APPROVED',
                                   calendars: [newer_calendar], professor_supervisors: [professor])
      create(:orientation, title: 'Projeto Alfa', status: 'CANCELED',
                           professor_supervisors: [professor])

      result = query(relation: professor.supervisions, segment: :history,
                     profile: :professor_supervision, status: 'APPROVED', term: 'Alfa')

      expect(result.map(&:id)).to eq([newer.id, older.id])
    end

    it 'lists external member current supervisions without adding preloads or ordering' do
      external_member = create(:external_member)
      orientation = create(:orientation, :current, :tcc_two,
                           external_member_supervisors: [external_member])
      create(:orientation, :current, :tcc_one, external_member_supervisors: [external_member])

      result = query(relation: external_member.supervisions, segment: :tcc_two,
                     profile: :external_member_supervision)

      expect(result).to contain_exactly(orientation)
    end

    it 'raises an explicit error for unsupported inputs' do
      relation = Orientation.all

      expect do
        query(relation:, segment: :current, profile: :professor_orientation)
      end.to raise_error(ArgumentError)

      expect do
        query(relation:, segment: :history, profile: :unknown)
      end.to raise_error(ArgumentError)
    end
  end
end

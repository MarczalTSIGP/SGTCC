require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe '#supervisors' do
    let!(:orientation) { create(:orientation) }
    let!(:professor) { create(:professor) }
    let!(:external_member) { create(:external_member) }

    before do
      professor.supervisions << orientation
      external_member.supervisions << orientation
    end

    it 'returns the supervisors' do
      supervisors = orientation.professor_supervisors + orientation.external_member_supervisors
      expect(orientation.supervisors).to eq(supervisors)
    end
  end

  describe '#professor_supervisors_to_document' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.professor_supervisors.first }

    it 'returns the array with professor supervisors name formatted' do
      formatted = [{ id: professor.id,
                     name: "#{professor.scholarity.abbr} #{professor.name}" }]
      expect(orientation.professor_supervisors_to_document).to match_array(formatted)
    end
  end

  describe '#external_member_supervisors_to_document' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }

    it 'returns the array with professor supervisors name formatted' do
      formatted = [{ id: external_member.id,
                     name: "#{external_member.scholarity.abbr} #{external_member.name}" }]
      expect(orientation.external_member_supervisors_to_document).to match_array(formatted)
    end
  end

  describe '#to_json_table' do
    let(:orientations) { create_list(:orientation, 2) }
    let(:orientation_methods) do
      [:short_title, :final_proposal, :final_project, :final_monograph,
       :document_title, :document_summary]
    end

    let(:orientations_json) do
      orientations.to_json(
        methods: orientation_methods,
        include: [:academic,
                  { supervisors: { methods: [:name_with_scholarity] } },
                  { advisor: { methods: [:name_with_scholarity] } }]
      )
    end

    it 'returns the orientation to json table' do
      expect(described_class.to_json_table(orientations)).to eq(orientations_json)
    end
  end

  describe '.document_tcc_one' do
    it 'returns the document tcc one' do
      orientation = create(:orientation, :tcc_one)
      document = create(:academic_activity, :proposal, academic: orientation.academic)
      orientation.calendars = [document.activity.calendar]

      expect(orientation.document_tcc_one).to eq(document)
    end
  end
end

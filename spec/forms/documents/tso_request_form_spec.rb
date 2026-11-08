require 'rails_helper'

RSpec.describe Documents::TsoRequestForm do
  let(:document) do
    build(:document_tso, request: {
            'requester' => { 'justification' => 'just' },
            'new_orientation' => { 'advisor' => { 'id' => 1 },
                                   'professorSupervisors' => [{ 'id' => 2 }, { 'id' => 3 }],
                                   'externalMemberSupervisors' => [] }
          })
  end

  def form(**attributes)
    described_class.new({ justification: 'nova', advisor_id: '1',
                          professor_supervisor_ids: ['', '2', '3'],
                          external_member_supervisor_ids: [''] }.merge(attributes))
  end

  describe 'selected ids' do
    it 'drops the hidden blank value and casts to integer' do
      expect(form).to have_attributes(professor_supervisor_ids: [2, 3],
                                      external_member_supervisor_ids: [])
    end

    it 'does not change the received values' do
      ids = ['', '2', '3']
      form(professor_supervisor_ids: ids).professor_supervisor_ids

      expect(ids).to eq(['', '2', '3'])
    end

    it 'treats missing ids as none' do
      expect(described_class.new.external_member_supervisor_ids).to eq([])
    end
  end

  describe '#orientation_changed?' do
    it 'is false when advisor and supervisors are the same' do
      expect(form.orientation_changed?(document)).to be(false)
    end

    it 'is true when the advisor changes' do
      expect(form(advisor_id: '9').orientation_changed?(document)).to be(true)
    end

    it 'is true when the professor supervisors change' do
      expect(form(professor_supervisor_ids: ['', '2']).orientation_changed?(document)).to be(true)
    end

    it 'is true when external member supervisors are added' do
      expect(form(external_member_supervisor_ids: ['', '7']).orientation_changed?(document))
        .to be(true)
    end
  end
end

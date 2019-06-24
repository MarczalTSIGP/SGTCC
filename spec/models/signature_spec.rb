require 'rails_helper'

RSpec.describe Signature, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to belong_to(:document) }
  end

  describe '#sign' do
    let(:signature) { create(:signature) }

    it 'returns the new status of the signature' do
      signature.sign
      expect(signature.status).to eq(true)
    end
  end

  describe '#term_of_commitement?' do
    let(:document_type) { create(:document_type, name: I18n.t('signatures.documents.TCO')) }
    let(:document) { create(:document, document_type: document_type) }
    let(:signature_tco) { create(:signature, document: document) }
    let(:signature) { create(:signature) }

    it 'returns true' do
      expect(signature_tco.term_of_commitment?).to eq(true)
    end

    it 'returns false' do
      expect(signature.term_of_commitment?).to eq(false)
    end
  end

  describe '#confirm' do
    context 'when professor confirm' do
      let!(:signature) { create(:signature) }
      let!(:professor) { create(:professor) }
      let(:params) { { login: professor.username, password: professor.password } }

      it 'returns true if the professors login is correct' do
        expect(signature.confirm(Professor, 'username', params)). to eq(true)
      end

      it 'returns false if the professors login is not correct' do
        params = { login: professor.username, password: '231' }
        expect(signature.confirm(Professor, 'username', params)). to eq(false)
      end
    end

    context 'when academic confirm' do
      let!(:signature) { create(:signature) }
      let!(:academic) { create(:academic) }
      let(:params) { { login: academic.ra, password: academic.password } }

      it 'returns true if the academics login is correct' do
        expect(signature.confirm(Academic, 'ra', params)). to eq(true)
      end

      it 'returns false if the academics login is not correct' do
        params = { login: academic.ra, password: '231' }
        expect(signature.confirm(Academic, 'ra', params)). to eq(false)
      end
    end

    context 'when external member confirm' do
      let!(:signature) { create(:signature) }
      let!(:external_member) { create(:external_member) }
      let(:params) { { login: external_member.email, password: external_member.password } }

      it 'returns true if the external member login is correct' do
        expect(signature.confirm(ExternalMember, 'email', params)). to eq(true)
      end

      it 'returns false if the external member login is not correct' do
        params = { login: external_member.email, password: '231' }
        expect(signature.confirm(ExternalMember, 'email', params)). to eq(false)
      end
    end
  end

  describe '#confirm_and_sign' do
    let!(:signature) { create(:signature) }
    let!(:professor) { create(:professor) }
    let(:params) { { login: professor.username, password: professor.password } }

    it 'returns true for the confirm and sign' do
      expect(signature.confirm_and_sign(Professor, 'username', params)). to eq(true)
      expect(signature.status). to eq(true)
    end

    it 'returns false if the confirm and sign' do
      params = { login: professor.username, password: '231' }
      expect(signature.confirm_and_sign(Professor, 'username', params)). to eq(false)
      expect(signature.status). to eq(false)
    end
  end

  describe '#can_view' do
    let(:professor) { create(:professor) }
    let(:academic) { create(:academic) }
    let(:orientation) { create(:orientation, advisor: professor) }
    let(:signature) { create(:signature, orientation_id: orientation.id, user_id: professor.id) }

    it 'returns true' do
      expect(signature.can_view(professor, 'professor')).to eq(true)
    end

    it 'returns false' do
      expect(signature.can_view(academic, 'academic')).to eq(false)
    end
  end

  describe '#by_professor_and_status' do
    let(:professor) { create(:professor) }
    let(:signature) { create(:signature, user_id: professor.id) }

    it 'returns the signature by professor and status' do
      signatures = Signature.where(user_id: professor.id, user_type: 'P', status: false)
      expect(Signature.by_professor_and_status(professor, false)).to eq(signatures)
    end
  end

  describe '#by_external_member_and_status' do
    let(:external_member) { create(:external_member) }
    let(:signature) { create(:signature, user_id: external_member.id) }

    it 'returns the signature by external_member and status' do
      signatures = Signature.where(user_id: external_member.id, user_type: 'E', status: false)
      expect(Signature.by_external_member_and_status(external_member, false)).to eq(signatures)
    end
  end

  describe '#by_academic_and_status' do
    let(:academic) { create(:academic) }
    let(:signature) { create(:signature, user_id: academic.id) }

    it 'returns the signature by academic and status' do
      signatures = Signature.where(user_id: academic.id, user_type: 'A', status: false)
      expect(Signature.by_academic_and_status(academic, false)).to eq(signatures)
    end
  end
end

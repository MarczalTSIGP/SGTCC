require 'rails_helper'

RSpec.describe Orientation do
  describe '#after_create' do
    let(:orientation) { create(:orientation) }
    let(:signatures) { orientation.signatures }

    before do
      orientation.signatures << Signature.all
    end
    # rubocop:disable RSpec/MultipleMemoizedHelpers

    context 'when is the tco signature' do
      let(:document_tco) { signatures.first.document }
      let(:tco_signatures) { signatures.where(document_id: document_tco.id) }
      let(:academic_signature) { tco_signatures.where(user_type: :academic).first }
      let(:advisor_signature) { tco_signatures.where(user_type: :advisor).first }

      let(:professor_supervisor_signature) do
        tco_signatures.where(user_type: :professor_supervisor).first
      end

      let(:external_member_signature) do
        tco_signatures.where(user_type: :external_member_supervisor).first
      end

      let(:academic) { academic_signature.user }
      let(:advisor) { advisor_signature.user }
      let(:professor_supervisor) { professor_supervisor_signature.user }
      let(:external_member_supervisor) { external_member_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Professor Supervisor signature' do
        attributes = { user_type: 'professor_supervisor',
                       user_id: professor_supervisor.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(professor_supervisor_signature).to have_attributes(attributes)
      end

      it 'returns the External Member Supervisor signature' do
        attributes = { user_type: 'external_member_supervisor',
                       user_id: external_member_supervisor.id,
                       status: false, document_id: document_tco.id,
                       orientation_id: orientation.id }
        expect(external_member_signature).to have_attributes(attributes)
      end

      it 'returns the signature count' do
        expect(tco_signatures.count).to eq(4)
      end
    end

    context 'when is the tcai signature' do
      let(:document_tcai) { signatures.last.document }
      let(:tcai_signatures) { signatures.where(document_id: document_tcai.id) }
      let(:academic_signature) { tcai_signatures.where(user_type: :academic).first }
      let(:advisor_signature) { tcai_signatures.where(user_type: :advisor).first }

      let(:professor_supervisor_signature) do
        tcai_signatures.where(user_type: :professor_supervisor).first
      end

      let(:external_member_signature) do
        tcai_signatures.where(user_type: :external_member_supervisor).first
      end

      let(:responsible_institution_signature) do
        tcai_signatures.where(user_type: :external_member_supervisor).last
      end

      let(:academic) { academic_signature.user }
      let(:advisor) { advisor_signature.user }
      let(:professor_supervisor) { professor_supervisor_signature.user }
      let(:external_member_supervisor) { external_member_signature.user }
      let(:responsible_institution_supervisor) { responsible_institution_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Professor Supervisor signature' do
        attributes = { user_type: 'professor_supervisor',
                       user_id: professor_supervisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(professor_supervisor_signature).to have_attributes(attributes)
      end

      it 'returns the External Member Supervisor signature' do
        attributes = { user_type: 'external_member_supervisor',
                       user_id: external_member_supervisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(external_member_signature).to have_attributes(attributes)
      end

      it 'returns the External Member Responsible Institution Supervisor signature' do
        attributes = { user_type: 'external_member_supervisor',
                       user_id: responsible_institution_supervisor.id,
                       status: false, document_id: document_tcai.id,
                       orientation_id: orientation.id }
        expect(responsible_institution_signature).to have_attributes(attributes)
      end

      it 'returns the signature count' do
        expect(tcai_signatures.count).to eq(5)
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe Document do
  describe '#after_create' do
    let!(:coordinator) { create(:coordinator) }
    let!(:responsible) { create(:responsible) }
    let!(:orientation) { create(:orientation, :current, :tcc_two) }

    context 'when returns the tdo signatures' do
      let!(:document) { create(:document_tdo, orientation_id: orientation.id) }
      let(:signatures) { document.signatures }
      let(:responsible_signature) { signatures.find_by(user_type: :professor_responsible) }
      let(:advisor_signature) { signatures.find_by(user_type: :advisor) }
      let(:advisor) { advisor_signature.user }

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Responsible signature' do
        attributes = { user_type: 'professor_responsible', user_id: responsible.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(responsible_signature).to have_attributes(attributes)
      end
    end

    context 'when returns the tep signatures' do
      let!(:document) { create(:document_tep, orientation_id: orientation.id) }
      let(:signatures) { document.signatures }
      let(:responsible_signature) { signatures.find_by(user_type: :professor_responsible) }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }
      let(:coordinator_signature) { signatures.find_by(user_type: :coordinator) }
      let(:academic) { academic_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Responsible signature' do
        attributes = { user_type: 'professor_responsible', user_id: responsible.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(responsible_signature).to have_attributes(attributes)
      end

      it 'returns the Coordinator signature' do
        attributes = { user_type: 'coordinator', user_id: coordinator.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(coordinator_signature).to have_attributes(attributes)
      end
    end

    context 'when returns the tso signatures' do
      let!(:new_advisor) { create(:professor) }

      let(:new_orientation) do
        { advisor: { id: new_advisor.id, name: new_advisor.name },
          professorSupervisors: {},
          externalMemberSupervisors: {} }
      end

      let(:request) do
        { requester: { justificatio: 'just' }, new_orientation: }
      end

      let!(:document) do
        create(:document_tso, orientation_id: orientation.id,
                              advisor_id: new_advisor.id, request:)
      end

      let(:signatures) { document.signatures }
      let(:responsible_signature) { signatures.find_by(user_type: :professor_responsible) }
      let(:advisor_signature) { signatures.find_by(user_type: :advisor) }
      let(:new_advisor_signature) { signatures.where(user_type: :new_advisor).last }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }
      let(:advisor) { advisor_signature.user }
      let(:academic) { academic_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the new Advisor signature' do
        attributes = { user_type: 'new_advisor', user_id: new_advisor.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(new_advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Responsible signature' do
        attributes = { user_type: 'professor_responsible', user_id: responsible.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(responsible_signature).to have_attributes(attributes)
      end
    end
  end

  describe 'callbacks' do
    let(:orientation) { build(:orientation) }
    let(:document_type) { create(:document_type, identifier: :tep) }

    let(:document) do
      build(:document,
            orientation_id: orientation.id,
            document_type: document_type,
            justification: 'Justificativa de teste')
    end

    describe 'when the document is created calls after_commit :on_create' do
      before do
        create(:responsible)
        allow(orientation).to receive(:create_tco_and_tcai).and_return(true)
        orientation.save!

        allow(document).to receive_messages(generate_unique_code: true, create_signatures: true,
                                            save_to_json: true, orientation: orientation)
      end

      it 'enqueues Notifications::CreateJob after create' do
        expect do
          document.save!
        end.to have_enqueued_job(Notifications::CreateJob)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers

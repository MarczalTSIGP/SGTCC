require 'rails_helper'

describe 'Document::sign', :js do
  let(:orientation) { create(:orientation) }
  let(:professor_signature) { orientation.signatures.find_by(user_type: :advisor) }
  let(:professor) { professor_signature.user }
  let(:document_signature) { professor_signature }
  let(:signature_user) { professor }
  let(:signature_message_strategy) { :text }
  let(:confirm_signature_message) { false }

  before do
    login_as(professor, scope: :professor)
    visit professors_document_path(orientation.tco)
  end

  describe '#sign' do
    context 'when signs the signature of the term of commitment' do
      def submit_valid_document_signature
        submit_document_signature(username: professor.username, password: 'password')
      end

      it_behaves_like 'a successful document signature flow',
                      'the term of commitment'
    end

    context 'when the password is wrong' do
      def submit_invalid_document_signature
        submit_document_signature(username: professor.username, password: '123')
      end

      it_behaves_like 'an invalid document signature flow'
    end
  end
end

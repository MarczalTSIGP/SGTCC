require 'rails_helper'

describe 'Document::sign', :js do
  let(:orientation) { create(:orientation) }
  let(:academic_signature) { orientation.signatures.where(user_type: :academic).first }
  let(:academic) { academic_signature.user }
  let(:document_signature) { academic_signature }
  let(:signature_user) { academic }
  let(:signature_message_strategy) { :modal }
  let(:confirm_signature_message) { true }

  before do
    login_as(academic, scope: :academic)
    visit academics_document_path(orientation.tco)
  end

  describe '#sign' do
    context 'when signs the signature of the term of commitment' do
      def submit_valid_document_signature
        submit_document_signature_form(username: academic.ra,
                                       password: 'password',
                                       form_selector: 'form')
      end

      it_behaves_like 'a successful document signature flow',
                      'the term of commitment'
    end

    context 'when the password is wrong' do
      def submit_invalid_document_signature
        submit_document_signature_form(username: academic.ra,
                                       password: 'wrongpassword',
                                       form_selector: 'form')
      end

      it_behaves_like 'an invalid document signature flow'
    end
  end
end

require 'rails_helper'

describe 'Document::sign', :js do
  let(:orientation) { create(:orientation) }
  let(:external_member_signature) do
    orientation.signatures.where(user_type: :external_member_supervisor).last
  end
  let(:external_member) { external_member_signature.user }
  let(:document_signature) { external_member_signature }
  let(:signature_user) { external_member }
  let(:signature_message_strategy) { :text }
  let(:confirm_signature_message) { false }

  before do
    login_as(external_member, scope: :external_member)
    visit external_members_document_path(Document.last)
  end

  describe '#sign' do
    context 'when signs the signature of the term of accept institution' do
      def submit_valid_document_signature
        submit_document_signature(username: external_member.email, password: 'password')
      end

      it_behaves_like 'a successful document signature flow',
                      'the term of accept institution'
    end

    context 'when the password is wrong' do
      def submit_invalid_document_signature
        submit_document_signature(username: external_member.email, password: '123')
      end

      it_behaves_like 'an invalid document signature flow'
    end
  end
end

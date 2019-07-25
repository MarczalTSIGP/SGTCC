require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let(:orientation) { create(:orientation) }

  before do
    orientation.signatures << Signature.all
    login_as(external_member, scope: :external_member)
  end

  describe '#show' do
    let(:signatures) { orientation.signatures }
    let(:external_member_signature) do
      signatures.where(user_type: :external_member_supervisor).first
    end
    let(:external_member) { external_member_signature.user }

    context 'when shows the signature of the term of commitment' do
      let(:active_link) { external_members_signatures_pending_path }

      before do
        visit external_members_signature_path(external_member_signature)
      end

      it 'shows the document of the term of commitment' do
        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       document_date(orientation.created_at)])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(scholarity_with_name(supervisor))
        end

        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when shows the signed signature of the term of commitment' do
      let(:document) { signatures.first.document }
      let(:document_type) { document.document_type }
      let(:active_link) { external_members_signatures_signed_path }

      before do
        signatures.each(&:sign)
        visit external_members_signature_path(external_member_signature)
      end

      it 'shows the document of the term of commitment' do
        role = signature_role(external_member.gender, external_member_signature.user_type)

        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       role,
                                       signature_code_message(document),
                                       document_date(orientation.created_at)])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(scholarity_with_name(supervisor))
        end

        Signature.mark(orientation.id, document_type.id).each do |signature|
          expect(page).to have_content(
            signature_register(signature[:name], signature[:role],
                               signature[:date], signature[:time])
          )
        end
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when the document signature cant be viewed' do
      before do
        academic_signature = signatures.where(user_type: :academic)
        visit external_members_signature_path(academic_signature)
      end

      it 'redirect to the signature pending page' do
        expect(page).to have_current_path external_members_signatures_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end

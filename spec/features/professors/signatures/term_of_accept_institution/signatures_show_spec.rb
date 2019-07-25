require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let(:orientation) { create(:orientation) }

  before do
    orientation.signatures << Signature.all
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    let(:signatures) { orientation.signatures }
    let(:professor_signature) { signatures.where(user_type: :advisor).last }
    let(:professor) { professor_signature.user }

    context 'when shows the pending signature of the term of accept institution' do
      let(:active_link) { professors_signatures_pending_path }

      it 'shows the document of the term of accept institution' do
        visit professors_signature_path(professor_signature)

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

    context 'when shows the signed signature of the term of accept institution' do
      let(:document) { signatures.last.document }
      let(:document_type) { document.document_type }
      let(:active_link) { professors_signatures_signed_path }

      before do
        signatures.each(&:sign)
        visit professors_signature_path(professor_signature)
      end

      it 'shows the document of the term of accept institution' do
        role = signature_role(professor.gender, professor_signature.user_type)

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
        em_signature = signatures.where(user_type: :external_member_supervisor)
        visit professors_signature_path(em_signature)
      end

      it 'redirect to the signature pending page' do
        expect(page).to have_current_path professors_signatures_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end

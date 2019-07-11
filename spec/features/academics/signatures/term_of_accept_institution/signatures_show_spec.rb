require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let!(:professor) { create(:professor) }
  let!(:external_member) { create(:external_member) }
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, advisor: professor, academic: academic) }
  let(:document_type) { create(:document_type_tcai) }
  let(:document) { create(:document, document_type: document_type) }

  before do
    login_as(academic, scope: :academic)
  end

  describe '#show' do
    context 'when shows the signature of the term of commitment' do
      let!(:signature) do
        create(:academic_signature,
               document: document,
               orientation_id: orientation.id,
               user_id: academic.id)
      end

      before do
        visit academics_signature_path(signature)
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
        expect(page).to have_selector("a[href='#{academics_signatures_pending_path}'].active")
      end
    end

    context 'when shows the signed signature of the term of commitment' do
      let(:signature) do
        create(:academic_signature_signed,
               document: document,
               orientation_id: orientation.id,
               user_id: academic.id)
      end

      before do
        create(:signature_signed,
               orientation_id: orientation.id,
               document: document,
               user_id: professor.id)

        create(:external_member_signature_signed,
               document: document,
               orientation_id: orientation.id,
               user_id: external_member.id)

        orientation.external_member_supervisors << external_member
        visit academics_signature_path(signature)
      end

      it 'shows the document of the term of commitment' do
        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.institution.trade_name,
                                       orientation.institution.external_member.name,
                                       scholarity_with_name(orientation.advisor),
                                       signature_role(academic.gender, signature.user_type),
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

        expect(page).to have_selector("a[href='#{academics_signatures_signed_path}'].active")
      end
    end

    context 'when the document signature cant be viewed' do
      before do
        signature = create(:signature)
        visit academics_signature_path(signature)
      end

      it 'redirect to the signature pending page' do
        expect(page).to have_current_path academics_signatures_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end

require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let!(:professor) { create(:professor) }
  let!(:academic) { create(:academic) }
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:orientation, advisor: professor) }
  let(:document_type) { create(:document_type_tco) }
  let(:document) { create(:document, document_type: document_type) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the pending signature of the term of commitment' do
      let!(:signature) do
        create(:signature,
               document: document,
               orientation_id: orientation.id,
               user_id: professor.id)
      end

      it 'shows the document of the term of commitment' do
        visit professors_signature_path(signature)
        academic = orientation.academic
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       document_date(orientation.created_at),
                                       academic.name,
                                       academic.email,
                                       academic.ra])
        active_link = professors_signatures_pending_path
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when shows the signed signature of the term of commitment' do
      before do
        signature = create(:signature_signed,
                           document: document,
                           orientation_id: orientation.id,
                           user_id: professor.id)

        create(:external_member_signature_signed,
               orientation_id: orientation.id,
               user_id: external_member.id)

        create(:academic_signature_signed,
               orientation_id: orientation.id,
               user_id: academic.id)

        orientation.external_member_supervisors << external_member
        visit professors_signature_path(signature)
      end

      it 'shows the document of the term of commitment' do
        academic = orientation.academic
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       document_date(orientation.created_at),
                                       academic.name,
                                       academic.email,
                                       academic.ra])
        orientation.signatures_mark.each do |signature|
          expect(page).to have_content(
            signature_register(signature[:name], signature[:date], signature[:time])
          )
        end
        active_link = professors_signatures_signed_path
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when the document signature cant be viewed' do
      before do
        academic_signature = create(:academic_signature)
        visit professors_signature_path(academic_signature)
      end

      it 'redirect to the signature pending page' do
        expect(page).to have_current_path professors_signatures_pending_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end

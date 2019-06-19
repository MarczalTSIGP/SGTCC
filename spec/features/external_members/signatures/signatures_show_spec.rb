require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let!(:professor) { create(:professor) }
  let!(:academic) { create(:academic) }
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:orientation, advisor: professor) }

  before do
    login_as(external_member, scope: :external_member)
    orientation.external_member_supervisors << external_member
  end

  describe '#show' do
    context 'when shows the signature of the term of commitment' do
      let!(:signature) do
        create(:signature, orientation_id: orientation.id)
      end

      it 'shows the document of the term of commitment' do
        visit external_members_signature_path(signature)
        academic = signature.orientation.academic
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       academic.name,
                                       academic.email,
                                       academic.ra])
        active_link = external_members_signatures_pending_path
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when shows the signed signature of the term of commitment' do
      before do
        signature = create(:signature_signed,
                           orientation_id: orientation.id,
                           user_id: professor.id)

        create(:external_member_signature_signed,
               orientation_id: orientation.id,
               user_id: external_member.id)

        create(:academic_signature_signed,
               orientation_id: orientation.id,
               user_id: academic.id)

        orientation.external_member_supervisors << external_member
        visit external_members_signature_path(signature)
      end

      it 'shows the document of the term of commitment' do
        academic = orientation.academic
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       academic.name,
                                       academic.email,
                                       academic.ra])
        orientation.signatures_mark.each do |signature|
          expect(page).to have_content(
            signature_register(signature[:name], signature[:date], signature[:time])
          )
        end
        active_link = external_members_signatures_signed_path
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end
  end
end

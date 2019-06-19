require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:orientation) }

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
      end
    end
  end
end

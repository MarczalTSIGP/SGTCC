require 'rails_helper'

describe 'Signature::show', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, academic: academic) }

  before do
    login_as(academic, scope: :academic)
  end

  describe '#show' do
    context 'when shows the signature of the term of commitment' do
      let!(:signature) do
        create(:signature, orientation_id: orientation.id)
      end

      it 'shows the document of the term of commitment' do
        visit academics_signature_path(signature)
        academic = orientation.academic
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       academic.name,
                                       academic.email,
                                       academic.ra])
      end
    end
  end
end

require 'rails_helper'

describe 'Supervision::documents', :js do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:current_orientation_tcc_one) }

  before do
    orientation.professor_supervisors << professor
    orientation.documents.each(&:save_to_json)
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when show the document by orientation' do
      let(:document) { orientation.documents.first }
      let(:active_link) { professors_supervisions_tcc_one_path }

      before do
        visit professors_supervision_document_path(orientation, document)
      end

      it_behaves_like 'orientation document show page'
    end
  end
end

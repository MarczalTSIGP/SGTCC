require 'rails_helper'

# Caracterização da regra "pedido não muda depois de assinado pelo solicitante" (REF-28).
RSpec.describe 'Authorization: requests' do
  describe 'academic TEP request' do
    let(:academic) { create(:academic) }
    let(:orientation) { create(:orientation, academic:) }
    let!(:document) { create(:document_tep, orientation_id: orientation.id) }
    let(:alert) { I18n.t('flash.documents.academics.requests.not_allowed') }

    before { login_as(academic, scope: :academic) }

    it 'allows editing before signing' do
      get edit_academics_tep_request_path(document)
      expect(response).to have_http_status(:ok)
    end

    context 'when the academic signed' do
      before { document.signature_by_user(academic, :academic).sign }

      it 'blocks editing' do
        get edit_academics_tep_request_path(document)
        expect(response).to redirect_to(academics_tep_requests_path)
        expect(flash[:alert]).to eq(alert)
      end

      it 'blocks updating' do
        patch academics_tep_request_path(document),
              params: { document: { justification: 'nova' } }
        expect(response).to redirect_to(academics_tep_requests_path)
        expect(flash[:alert]).to eq(alert)
      end

      it 'blocks destroying' do
        expect { delete academics_tep_request_path(document) }.not_to change(Document, :count)
        expect(response).to redirect_to(academics_tep_requests_path)
      end
    end
  end

  describe 'professor TDO request' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation, advisor: professor) }
    let!(:document) { create(:document_tdo, orientation_id: orientation.id) }
    let(:alert) { I18n.t('flash.documents.professors.requests.not_allowed') }

    before { login_as(professor, scope: :professor) }

    it 'allows editing before signing' do
      get edit_professors_request_path(document)
      expect(response).to have_http_status(:ok)
    end

    context 'when the professor signed' do
      before { document.signature_by_user(professor.id, professor.user_types).sign }

      it 'blocks editing' do
        get edit_professors_request_path(document)
        expect(response).to redirect_to(professors_requests_path)
        expect(flash[:alert]).to eq(alert)
      end

      it 'blocks updating' do
        patch professors_request_path(document), params: { document: { justification: 'nova' } }
        expect(response).to redirect_to(professors_requests_path)
        expect(flash[:alert]).to eq(alert)
      end
    end
  end
end

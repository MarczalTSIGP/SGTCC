require 'rails_helper'

RSpec.describe ErrorsController do
  describe '#show' do
    context 'when resource is not found' do
      it 'responds with 404' do
        get :show, params: { code: '404' }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when resource is unprocessable entity' do
      it 'responds with 422' do
        get :show, params: { code: '422' }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when resource is internal server error' do
      it 'responds with 500' do
        get :show, params: { code: '500' }
        expect(response).to have_http_status(:internal_server_error)
      end
    end

    context 'when the request format is xml' do
      it 'responds with 404 without rendering an html template' do
        get :show, params: { code: '404' }, format: :xml

        expect(response).to have_http_status(:not_found)
        expect(response.body).to be_blank
      end
    end
  end
end

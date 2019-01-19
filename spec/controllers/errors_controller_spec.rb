require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do

  describe '#show' do

    it 'renders the 404 error page when it receives a 404 status code' do
      get :show, params: { code: '404' }
      expect(response).to have_http_status(404)
    end

    it 'renders the 422 error page when it receives a 422 status code' do
      get :show, params: { code: '422' }
      expect(response).to have_http_status(422)
    end

    it 'renders the 500 error page when it receives a 500 status code' do
      get :show, params: { code: '500' }
      expect(response).to have_http_status(500)
    end
  end

end

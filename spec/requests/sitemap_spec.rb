require 'rails_helper'

RSpec.describe 'Sitemap', type: :request do
  it 'returns 404 for sitemap.xml without going through the page catch-all route' do
    get '/sitemap.xml'

    expect(response).to have_http_status(:not_found)
    expect(response.media_type).to eq('application/xml')
    expect(response.body).to be_blank
  end
end

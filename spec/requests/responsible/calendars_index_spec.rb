require 'rails_helper'

# A rota `GET /responsible/calendars` existe, mas nenhum link da aplicação a usa. Antes, a
# ação não existia e a view era renderizada com `@calendars` nulo (HTTP 500).
RSpec.describe 'Responsible calendars index' do
  before { login_as(create(:responsible), scope: :professor) }

  it 'redirects to the TCC I calendars list' do
    get responsible_calendars_path

    expect(response).to redirect_to(responsible_calendars_tcc_one_path)
  end

  it 'keeps the per-TCC lists working' do
    get responsible_calendars_tcc_two_path

    expect(response).to have_http_status(:ok)
  end
end

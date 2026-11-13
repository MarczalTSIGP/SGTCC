require 'rails_helper'

# Caracterização do acesso às áreas restritas por papel do professor (REF-28).
RSpec.describe 'Authorization: professor roles' do
  let(:not_authorized) { I18n.t('flash.not_authorized') }

  it 'lets a responsible professor into the responsible area' do
    login_as(create(:responsible), scope: :professor)
    get responsible_root_path
    expect(response).to have_http_status(:ok)
  end

  it 'keeps a professor without the role out of the responsible area' do
    login_as(create(:professor), scope: :professor)
    get responsible_root_path
    expect(response).to redirect_to(professors_root_path)
    expect(flash[:alert]).to eq(not_authorized)
  end

  it 'lets a TCC I professor into the TCC I area' do
    login_as(create(:professor_tcc_one), scope: :professor)
    get tcc_one_professors_root_path
    expect(response).to have_http_status(:ok)
  end

  it 'keeps a professor without the role out of the TCC I area' do
    login_as(create(:professor), scope: :professor)
    get tcc_one_professors_root_path
    expect(response).to redirect_to(professors_root_path)
    expect(flash[:alert]).to eq(not_authorized)
  end
end

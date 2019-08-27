require 'rails_helper'

describe 'ExternalMember::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:external_member) { create(:external_member) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_external_member_path(external_member)
  end

  describe '#show' do
    context 'when shows the external member' do
      it 'shows the external member' do
        gender = I18n.t("enums.genders.#{external_member.gender}")
        is_active = I18n.t("helpers.boolean.#{external_member.is_active}")

        expect(page).to have_contents([external_member.name,
                                       external_member.email,
                                       external_member.scholarity.name,
                                       external_member.personal_page,
                                       gender,
                                       is_active,
                                       complete_date(external_member.created_at),
                                       complete_date(external_member.updated_at)])
      end
    end
  end
end

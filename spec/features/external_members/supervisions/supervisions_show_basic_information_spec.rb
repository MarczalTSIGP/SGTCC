require 'rails_helper'

describe 'Supervision::show' do
  before do
    ProfessorType.find_or_create_by(id: 2) { |pt| pt.name = 'Tipo 2' }
    ProfessorType.find_or_create_by(id: 12) { |pt| pt.name = 'Tipo 12' }

    max_id = ProfessorType.maximum(:id) || 0
    sequence_name = "#{ProfessorType.table_name}_id_seq"

    ActiveRecord::Base.connection.execute(
      "SELECT setval('#{sequence_name}', #{max_id + 1}, false);"
    )
    external_member.supervisions << orientation
    external_member.supervisions << orientation_tcc_one
    external_member.supervisions << orientation_tcc_two
    login_as(external_member, scope: :external_member)
  end

  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:orientation) }
  let(:orientation_tcc_one) { create(:current_orientation_tcc_one) }
  let(:orientation_tcc_two) { create(:current_orientation_tcc_two) }

  describe '#show' do
    context 'when shows the orientation' do
      it 'shows the orientation' do
        visit external_members_supervision_path(orientation)

        expect_orientation_show_basic_information(orientation)

        I18n.t('breadcrumbs.supervisions.history')
        first("a[href='#{external_members_supervisions_history_path}']",
              text: 'Histórico').click
        expect(page).to have_current_path external_members_supervisions_history_path
      end
    end
  end
end

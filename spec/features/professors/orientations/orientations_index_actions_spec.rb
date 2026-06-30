require 'rails_helper'

describe 'Orientation::index' do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', :js do
    context 'when shows orientation action links' do
      let!(:orientation) { create(:current_orientation_tcc_one, advisor: professor) }
      let(:index_url) { professors_orientations_tcc_one_path }
      let(:orientation_link) { "a[href='#{professors_orientation_path(orientation)}']" }

      before { visit index_url }

      it 'clicks on academic name and shows "Detalhes da orientação" link' do
        find(orientation_link).click

        expect(page).to have_link(
          'Detalhes da orientação',
          href: professors_orientation_path(orientation)
        )
      end

      it 'clicks on academic name and shows "Visualizar atividades" link' do
        find(orientation_link).click

        expect(page).to have_link(
          'Atividades da orientação',
          href: professors_orientation_calendar_activities_path(
            orientation, orientation.current_calendar
          )
        )
      end

      it 'clicks on academic name and shows "Visualizar documentos" link' do
        find(orientation_link).click

        expect(page).to have_link(
          'Documentos da orientação',
          href: professors_orientation_documents_path(orientation)
        )
      end

      it 'clicks on academic name and shows "Visualizar reuniões" link if available' do
        find(orientation_link).click

        if orientation.meetings.any?
          expect(page).to have_link(
            'Reuniões da orientação',
            href: professors_orientation_meetings_path(orientation)
          )
        else
          expect(page).to have_no_link('Visualizar reuniões')
        end
      end

      it 'clicks on academic name and shows "Editar" link if allowed' do
        find(orientation_link).click

        if orientation.can_be_edited?
          expect(page).to have_link(
            'Editar',
            href: edit_professors_orientation_path(orientation)
          )
        else
          expect(page).to have_no_link('Editar')
        end
      end
    end
  end
end

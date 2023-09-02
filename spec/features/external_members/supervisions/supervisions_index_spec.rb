describe 'Supervision::index', type: :feature, js: true do
  let(:external_member) { create(:external_member) }

  before do
    login_as(external_member, scope: :external_member)
  end

  describe '#index' do
    context 'when shows all the supervisions of tcc one calendar' do
      it 'shows basic information of tcc one supervision' do
        orientation = create(:current_orientation_tcc_one)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_one_path
        visit index_url

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_link(
          orientation.academic.name,
          href: external_members_supervision_path(orientation)
        )
      end

      it 'shows calendar information of tcc one supervision' do
        orientation = create(:current_orientation_tcc_one)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_one_path
        visit index_url

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end
      end

      it 'shows active link for tcc one supervision' do
        orientation = create(:current_orientation_tcc_one)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_one_path
        visit index_url

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'clicks on academic name and shows additional options' do
        orientation = create(:current_orientation_tcc_one)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_one_path
        visit index_url

        find('.academic-name-link').click
        expect(page).to have_link(
          'Detalhes da orientação',
          href: external_members_supervision_path(orientation)
        )
        expect(page).to have_link(
          'Visualizar atividades',
          href: external_members_supervision_calendar_activities_path(
            orientation, orientation.current_calendar
          )
        )
        expect(page).to have_link(
          'Visualizar documentos',
          href: external_members_supervision_documents_path(orientation)
        )
      end
    end

    context 'when shows all the supervisions of tcc two calendar' do
      it 'shows basic information of tcc two supervision' do
        orientation = create(:current_orientation_tcc_two)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_two_path
        visit index_url

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_content(orientation.academic.name)
      end

      it 'shows calendar information of tcc two supervision' do
        orientation = create(:current_orientation_tcc_two)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_two_path
        visit index_url

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end
      end

      it 'shows active link for tcc two supervision' do
        orientation = create(:current_orientation_tcc_two)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_two_path
        visit index_url

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end

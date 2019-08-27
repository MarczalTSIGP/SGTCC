require 'rails_helper'

describe 'Professor::index', type: :feature, js: true do
  let!(:responsible) { create(:responsible) }
  let!(:professors) { create_list(:professor, 5) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#index' do
    context 'when shows all professors' do
      it 'shows all professors with options' do
        visit responsible_professors_path
        professors.each do |professor|
          expect(page).to have_contents([professor.name,
                                         professor.email,
                                         short_date(professor.created_at)])
          expect(page).to have_selector(link(professor.lattes))
        end
      end
    end

    context 'when shows all available advisor professors' do
      it 'shows all available professors with options' do
        visit responsible_professors_available_path

        Professor.available_advisor.each do |professor|
          expect(page).to have_contents([professor.name,
                                         professor.email,
                                         short_date(professor.created_at)])
          expect(page).to have_selector(link(professor.lattes))
        end
      end
    end

    context 'when shows all unavailable advisor professors' do
      it 'shows all unavailable professors with options' do
        visit responsible_professors_unavailable_path

        Professor.unavailable_advisor.each do |professor|
          expect(page).to have_contents([professor.name,
                                         professor.email,
                                         short_date(professor.created_at)])
          expect(page).to have_selector(link(professor.lattes))
        end
      end
    end
  end
end

require 'rails_helper'

describe 'Professor::pagination', :js do
  let(:responsible) { create(:responsible) }

  # O nome é explícito para ordenar por último: as sequences da factory ("Professor 1",
  # "Professor 2"...) continuam contando entre exemplos, então qual delas é a última em
  # ordem alfabética depende de quantos professores os exemplos anteriores criaram.
  let!(:last_professor) { create(:professor, name: 'Zzz Último Professor') }

  before do
    login_as(responsible, scope: :professor)
    create_list(:professor, 30) # rubocop:disable FactoryBot/ExcessiveCreateList
    visit responsible_professors_path
  end

  describe '#pagination' do
    context 'when finds the last professor on second page' do
      it 'finds the last professor' do
        professor = last_professor
        click_link('2')
        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.username,
                                       short_date(professor.created_at)])
        expect(page).to have_selector(link(professor.lattes))
      end
    end
  end
end

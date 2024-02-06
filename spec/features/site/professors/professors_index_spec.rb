require 'rails_helper'

describe 'Professor::index', :js do
  let!(:effective_professor_type) { create(:professor_type, name: 'Efetivo') }
  let!(:temporary_professor_type) { create(:professor_type, name: 'Temporário') }
  let!(:effective_professor) { create(:professor, professor_type: effective_professor_type) }
  let!(:temporary_professor) { create(:professor, professor_type: temporary_professor_type) }
  let(:professors) { [effective_professor, temporary_professor] }

  before do
    create(:page, url: 'professores')
    visit site_professors_path
  end

  describe '#index' do
    context 'when shows all professors' do
      it 'shows all professors with options' do
        professors.each do |professor|
          available_advisor = I18n.t("helpers.boolean.#{professor.available_advisor}")

          expect(page).to have_contents([professor.name_with_scholarity,
                                         available_advisor,
                                         professor.email])
          expect(page).to have_selector(link(professor.lattes))
        end
      end
    end
  end
end

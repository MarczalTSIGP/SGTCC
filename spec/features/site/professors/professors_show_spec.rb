require 'rails_helper'

describe 'Professors::show', type: :feature do
  let!(:professor) { create(:professor) }

  before do
    visit site_professor_path(professor)
  end

  describe '#show' do
    context 'when shows the professor' do
      it 'show the professor' do
        available_advisor = I18n.t("helpers.boolean.#{professor.available_advisor}")

        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.lattes,
                                       available_advisor,
                                       professor.scholarity.name,
                                       professor.professor_type.name])
      end
    end

    context 'when shows the approved orientations' do
      it 'show the tcc one orientations' do
        professor.tcc_one_approved.each do |orientation|
          expect(page).to have_contents([orientation.document_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end

      it 'show the tcc two orientations' do
        professor.tcc_two_approved.each do |orientation|
          expect(page).to have_contents([orientation.document_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end
    end

    context 'when shows the in progress orientations' do
      it 'show the tcc one orientations' do
        professor.tcc_one_in_progress.each do |orientation|
          expect(page).to have_contents([orientation.document_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end

      it 'show the tcc two orientations' do
        professor.tcc_two_in_progress.each do |orientation|
          expect(page).to have_contents([orientation.document_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end
    end
  end
end

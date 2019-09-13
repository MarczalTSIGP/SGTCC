require 'rails_helper'

describe 'Professors::show', type: :feature do
  let!(:professor) { create(:professor) }

  before do
    visit site_professor_path(professor)
  end

  describe '#show' do
    context 'when shows the professor' do
      it 'show the professor' do
        gender = I18n.t("enums.genders.#{professor.gender}")
        is_active = I18n.t("helpers.boolean.#{professor.is_active}")
        available_advisor = I18n.t("helpers.boolean.#{professor.available_advisor}")

        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.username,
                                       professor.lattes,
                                       gender,
                                       is_active,
                                       available_advisor,
                                       professor.scholarity.name,
                                       professor.professor_type.name])
      end
    end

    context 'when shows the approved orientations' do
      it 'show the tcc one orientations' do
        professor.tcc_one_approved_orientations.each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end

      it 'show the tcc two orientations' do
        professor.tcc_two_approved_orientations.each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end
    end

    context 'when shows the in progress orientations' do
      it 'show the tcc one orientations' do
        professor.tcc_one_in_progress_orientations.each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end

      it 'show the tcc two orientations' do
        professor.tcc_two_in_progress_orientations.each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end
    end

    context 'when shows the orientations report' do
      let(:report) { professor.total_orientations_report }
      let(:tcc_one_report) { report[:tcc_one] }
      let(:tcc_two_report) { report[:tcc_two] }

      it 'show the tcc one reports' do
        expect(page).to have_contents([tcc_one_report[:approved],
                                       tcc_one_report[:in_progress]])
      end

      it 'show the tcc two reports' do
        expect(page).to have_contents([tcc_two_report[:approved],
                                       tcc_two_report[:in_progress]])
      end
    end
  end
end

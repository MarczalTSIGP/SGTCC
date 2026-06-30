module ExaminationBoardShowExamples
  def expect_examination_board_basic_information
    expect(page).to have_contents(examination_board_basic_information_contents)
  end

  def expect_examination_board_evaluators_basic_information
    each_examination_board_evaluator_response do |response|
      expect_evaluator_basic_information(response)
    end
  end

  def expect_evaluator_basic_information(response)
    expect(page).to have_text(response.evaluator.name_with_scholarity)
    expect_boolean_text(response.appointments_file?)
    expect_boolean_text(response.appointments_text?)
  end

  def expect_boolean_text(value)
    expect(page).to have_text(boolean_translation(value))
  end

  def examination_board_basic_information_contents
    [examination_board.orientation.title,
     examination_board.orientation.academic_with_calendar,
     examination_board.orientation.advisor.name_with_scholarity,
     examination_board.place,
     complete_date(examination_board.date)]
  end

  def each_examination_board_evaluator_response
    within('table.table') do
      examination_board.evaluators.responses.each_with_index do |response, index|
        within("tbody tr:nth-child(#{index + 1})") do
          yield response
        end
      end
    end
  end

  def create_examination_board_notes
    examination_board.evaluators.responses.each do |response|
      create(:examination_board_note, examination_board_note_params(response))
    end
  end

  def examination_board_note_params(response)
    evaluator_key = response.evaluator.is_a?(Professor) ? :professor_id : :external_member_id

    { evaluator_key => response.evaluator.id,
      note: 100,
      examination_board: }
  end

  def expect_examination_board_evaluator_appointments
    each_examination_board_evaluator_response do |response|
      expect(page).to have_css("a[href='#{response.appointments_file.url}']")
      expect(page).to have_link(boolean_translation(response.appointments_text?))
    end
  end

  def boolean_translation(value)
    I18n.t("helpers.boolean.#{value}")
  end

  def expect_examination_board_academic_note(academic_name)
    expect(page).to have_contents([academic_name,
                                   examination_board.final_note,
                                   examination_board.situation_translated])
  end

  def expect_examination_board_academic_activity(verify_monograph: false)
    expect(orientation.monograph).to eq(academic_activity) if verify_monograph
    expect(page).to have_contents(examination_board_academic_activity_contents)

    expect(page).to have_selectors(examination_board_academic_activity_links)
  end

  def examination_board_academic_activity_contents
    [academic.name,
     academic_activity.title,
     academic_activity.summary]
  end

  def examination_board_academic_activity_links
    [link(academic_activity.pdf.url),
     link(academic_activity.complementary_files.url)]
  end
end

RSpec.configure do |config|
  config.include ExaminationBoardShowExamples
end

RSpec.shared_examples 'examination board basic information' do |description|
  it description do
    expect_examination_board_basic_information
  end

  it 'show the evaluators' do
    expect_examination_board_evaluators_basic_information
  end
end

RSpec.shared_examples 'examination board appointments' do
  it 'show the evaluators' do
    expect_examination_board_evaluator_appointments
  end
end

RSpec.shared_examples 'examination board academic note' do
  it 'shows the academic note' do
    expect_examination_board_academic_note(academic_note_name)
  end
end

RSpec.shared_examples 'examination board academic activity' do |verify_monograph: false|
  it 'shows the academic activity' do
    expect_examination_board_academic_activity(verify_monograph:)
  end
end

module ExaminationBoardCreateExamples
  def expect_examination_board_required_errors
    expect(page).to have_flash(:danger, text: errors_message)
    expect(page).to have_message(blank_error_message, in: 'div.examination_board_place')
    expect(page).to have_message(required_error_message,
                                 in: 'div.examination_board_orientation')
  end

  def expect_examination_board_created(path:, place:, show_orientation: true)
    expect(page).to have_current_path path
    expect(page).to have_flash(:success, text: message('create.f'))
    expect(page).to have_message(place, in: 'table tbody')
    expect_created_examination_board_orientation if show_orientation
  end

  def expect_created_examination_board_orientation
    expect(page).to have_text(orientation.academic_with_calendar)
  end

  def expect_orientation_select_without_tcc(tcc)
    open_orientation_select
    expect_orientation_select_options_without_tcc(tcc)
    close_orientation_select
  end

  def open_orientation_select
    within(parent_element) do
      button = find("[data-id^='ss-']", wait: 5)
      button.click
    end
  end

  def expect_orientation_select_options_without_tcc(tcc)
    orientation_select_options.each do |option|
      expect(option.text).not_to match(/TCC: #{tcc}/i)
    end
  end

  def orientation_select_options
    dropdown = find('div.ss-content', visible: true, wait: 5)
    dropdown.all("div[role='option']", wait: 5)
  end

  def close_orientation_select
    page.execute_script("document.querySelectorAll('.ss-content').forEach(el => el.remove())")
  end

  def parent_element
    select_element = find('select#examination_board_orientation_id', visible: :all)
    select_element.find(:xpath, './..')
  end
end

RSpec.configure do |config|
  config.include ExaminationBoardCreateExamples
end

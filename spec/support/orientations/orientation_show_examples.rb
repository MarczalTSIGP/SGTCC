module OrientationShowExamples
  def expect_orientation_show_basic_information(orientation)
    expect_orientation_show_people_information(orientation)
    expect_orientation_show_calendar_information(orientation)
    expect_orientation_show_timestamp_information(orientation)
  end

  def expect_orientation_show_people_information(orientation)
    expect(page).to have_text(orientation.title)
    expect(page).to have_text(orientation.academic.name)
    expect(page).to have_text(orientation.advisor.name)
  end

  def expect_orientation_show_calendar_information(orientation)
    orientation.calendars.each do |calendar|
      expect(page).to have_text(calendar.year_with_semester_and_tcc)
    end
  end

  def expect_orientation_show_timestamp_information(orientation)
    expect(page).to have_text(complete_date(orientation.created_at))
    expect(page).to have_text(complete_date(orientation.updated_at))
  end
end

RSpec.configure do |config|
  config.include OrientationShowExamples
end

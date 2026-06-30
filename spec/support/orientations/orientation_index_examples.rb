module OrientationIndexExamples
  def expect_orientation_index_basic_information(orientation)
    expect_orientation_index_people_information(orientation)
    expect_orientation_index_calendar_information(orientation)
  end

  def expect_orientation_index_people_information(orientation)
    expect(page).to have_text(orientation.short_title)
    expect(page).to have_text(orientation.advisor.name)
    expect(page).to have_text(orientation.academic.name)
  end

  def expect_orientation_index_calendar_information(orientation)
    orientation.calendars.each do |calendar|
      expect(page).to have_text(calendar.year_with_semester_and_tcc)
    end
  end

  def expect_active_index_link(index_url)
    expect(page).to have_css("a[href='#{index_url}'].active")
  end
end

RSpec.configure do |config|
  config.include OrientationIndexExamples
end

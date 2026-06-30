module OrientationActivityShowExamples
  def expect_orientation_activity_contents(academic_activity)
    expect(page).to have_contents(orientation_activity_contents(academic_activity))
  end

  def orientation_activity_contents(academic_activity)
    [*orientation_activity_basic_contents,
     academic.name,
     academic_activity.title,
     academic_activity.summary]
  end

  def orientation_activity_basic_contents
    [activity.name,
     activity.base_activity_type.name,
     activity.deadline,
     I18n.t("enums.tcc.#{activity.tcc}"),
     complete_date(activity.created_at),
     complete_date(activity.updated_at)]
  end

  def expect_orientation_activity_links(active_link)
    expect(page).to have_selectors([link(academic_activity.pdf.url),
                                    link(academic_activity.complementary_files.url),
                                    "#{link(active_link)}.active"])
  end
end

RSpec.configure do |config|
  config.include OrientationActivityShowExamples
end

RSpec.shared_examples 'orientation activity show page' do
  it 'shows the activity' do
    expect_orientation_activity_contents(academic_activity)
    expect_orientation_activity_links(active_link)
  end
end

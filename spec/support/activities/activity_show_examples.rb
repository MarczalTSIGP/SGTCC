module ActivityShowExamples
  def expect_activity_basic_information
    expect(page).to have_contents(activity_basic_information_contents)
  end

  def activity_basic_information_contents
    [activity.name,
     activity.base_activity_type.name,
     activity.deadline,
     I18n.t("enums.tcc.#{activity.tcc}"),
     complete_date(activity.created_at),
     complete_date(activity.updated_at)]
  end

  def expect_activity_responses(show_response_links: true)
    within('table.table') do
      activity.responses.academics.each_with_index do |academic, index|
        expect_activity_response(academic, index, show_response_links:)
      end

      expect(page).to have_text(activity.responses.entries_info)
    end
  end

  def expect_activity_response(academic, index, show_response_links:)
    within("tbody tr:nth-child(#{index + 1})") do
      sent_value = I18n.t("helpers.boolean.#{academic.sent?}")

      expect_activity_response_text(academic, sent_value)
      expect(page).to have_no_link(sent_value) unless show_response_links
    end
  end

  def expect_activity_response_text(academic, sent_value)
    expect(page).to have_text(academic.name)
    expect(page).to have_text(sent_value)
  end

  def expect_sent_activity_response_link(path)
    within('table.table tbody') do
      expect(page).to have_link(I18n.t('helpers.boolean.true'), href: path)
    end
  end

  def expect_no_sent_activity_response_link(path)
    within('table.table tbody') do
      expect(page).to have_no_link(I18n.t('helpers.boolean.true'), href: path)
    end
  end
end

RSpec.configure do |config|
  config.include ActivityShowExamples
end

RSpec.shared_examples 'activity show basic information' do
  it 'base info' do
    expect_activity_basic_information
  end
end

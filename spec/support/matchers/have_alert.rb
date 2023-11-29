RSpec::Matchers.define :have_alert do |options|
  match do |page|
    expect(page).to have_css('div.swal-text', text: options[:text], wait: 5)
  end
  failure_message do
    "expected that page have alert message with '#{options[:text]}'"
  end
end

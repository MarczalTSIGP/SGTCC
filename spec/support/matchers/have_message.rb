RSpec::Matchers.define :have_message do |content, options|
  match do |page|
    page.find(options[:in], wait: 5).has_content?(content.to_s)
  end
  failure_message do
    "expected that page have #{content} error message in '#{options[:in]}'"
  end
end

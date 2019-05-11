RSpec::Matchers.define :have_message do |content, options|
  match do |page|
    page.find(options[:in]).has_content?(content)
  end
  failure_message do
    "expected that page have #{content} error message in '#{options[:in]}'"
  end
end

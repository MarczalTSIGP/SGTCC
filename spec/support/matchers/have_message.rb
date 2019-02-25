RSpec::Matchers.define :have_message do |content, options|
  match do |page|
    within(options[:in]) do
      expect(page).to have_content(content)
    end
  end
  failure_message do
    "expected that page have #{content} error message in '#{options[:in]}'"
  end
end

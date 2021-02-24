RSpec::Matchers.define :have_contents do |expecteds|
  match do |page|
    expecteds.each do |content|
      expect(page).to have_content(content.to_s)
    end
  end
end

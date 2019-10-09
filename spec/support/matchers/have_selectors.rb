RSpec::Matchers.define :have_selectors do |expecteds|
  match do |page|
    expecteds.each do |content|
      expect(page).to have_selector(content)
    end
  end
end

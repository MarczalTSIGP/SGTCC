FactoryBot.define do
  factory :site do
    sequence(:title) { |n| "Site #{n}" }
  end
end

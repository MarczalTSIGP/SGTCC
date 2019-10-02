FactoryBot.define do
  factory :image do
    sequence(:name) { Faker::Name.name }
    url { File.open(FileSpecHelper.image.path) }
  end
end

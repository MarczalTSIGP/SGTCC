FactoryBot.define do
  factory :attached_document do
    sequence(:name) { Faker::Name.name }
    file { File.open(FileSpecHelper.pdf.path) }
  end
end

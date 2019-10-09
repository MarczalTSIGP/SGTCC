FactoryBot.define do
  factory :academic_activity do
    academic
    activity
    pdf { File.open(FileSpecHelper.pdf.path) }
    complementary_files { File.open(FileSpecHelper.zip.path) }
    sequence(:title) { Faker::Name.name }
    summary { Faker::Lorem.paragraph }
  end
end

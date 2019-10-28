FactoryBot.define do
  factory :academic_activity do
    academic
    activity
    pdf { File.open(FileSpecHelper.pdf.path) }
    complementary_files { File.open(FileSpecHelper.zip.path) }
    sequence(:title) { Faker::Name.name }
    summary { Faker::Lorem.paragraph }

    factory :proposal_academic_activity do
      activity { create(:proposal_activity) }
    end

    factory :project_academic_activity do
      activity { create(:project_activity) }
    end

    factory :monograph_academic_activity do
      activity { create(:monograph_activity) }
    end
  end
end

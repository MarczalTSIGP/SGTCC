FactoryBot.define do
  factory :academic_activity do
    transient do
      calendar { nil }
    end

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

    after(:create) do |academic_activity, evaluator|
      if evaluator.calendar
        activity = academic_activity.activity
        activity.update(calendar_id: evaluator.calendar.id)
      end
    end
  end

  factory :academic_activity_without_complementary_files, parent: :academic_activity do
    complementary_files { nil }
  end
end

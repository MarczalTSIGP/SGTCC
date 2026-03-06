FactoryBot.define do
  factory :academic_activity do
    academic

    transient do
      calendar { nil }
    end

    association :activity

    after(:build) do |academic_activity, evaluator|
      if evaluator.calendar.present?
        academic_activity.activity = create(:activity, calendar: evaluator.calendar)
      end
    end

    pdf { File.open(FileSpecHelper.pdf.path) }
    complementary_files { File.open(FileSpecHelper.zip.path) }
    sequence(:title) { Faker::Name.name }
    summary { Faker::Lorem.paragraph }

    factory :proposal_academic_activity do
      activity { association(:proposal_activity) }
    end

    factory :project_academic_activity do
      activity { association(:project_activity) }
    end

    factory :monograph_academic_activity do
      activity { association(:monograph_activity) }
    end
  end

  factory :academic_activity_no_complementary_files, parent: :academic_activity do
    complementary_files { nil }
  end
end

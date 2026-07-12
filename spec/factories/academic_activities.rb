FactoryBot.define do
  factory :academic_activity do
    academic

    transient do
      calendar { nil }
    end

    activity

    after(:build) do |academic_activity, evaluator|
      if evaluator.calendar.present?
        academic_activity.activity = create(:activity, calendar: evaluator.calendar)
      end
    end

    pdf { File.open(FileSpecHelper.pdf.path) }
    complementary_files { File.open(FileSpecHelper.zip.path) }
    sequence(:title) { Faker::Name.name }
    summary { Faker::Lorem.paragraph }

    trait :proposal do
      activity { association(:activity, :proposal) }
    end

    trait :project do
      activity { association(:activity, :project) }
    end

    trait :monograph do
      activity { association(:activity, :monograph) }
    end

    trait :without_complementary_files do
      complementary_files { nil }
    end
  end
end

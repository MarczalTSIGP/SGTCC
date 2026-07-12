FactoryBot.define do
  calendar_from_traits = lambda do |traits|
    period = (traits & [:current, :previous, :next]).first || :current
    tcc_trait = (traits & [:tcc_one, :tcc_two]).first || :tcc_one
    calendar = FactoryBot.build(:calendar, period, tcc_trait)

    Calendar.find_by(year: calendar.year, semester: calendar.semester, tcc: calendar.tcc) ||
      FactoryBot.create(
        :calendar,
        year: calendar.year,
        semester: calendar.semester,
        tcc: calendar.tcc,
        start_date: calendar.start_date,
        end_date: calendar.end_date
      )
  end

  factory :orientation do
    title { Faker::Lorem.sentence(word_count: 3) }
    advisor { association(:professor) }
    academic
    institution
    renewal_justification { Faker::Lorem.sentence(word_count: 3) }
    status { Orientation.statuses.key('IN_PROGRESS') }

    transient do
      calendar_period { :current }
      calendar_tcc { :tcc_one }
      skip_calendar_association { false }
    end

    before :create do
      create(:document_type_tco) if DocumentType.tco.empty?
      create(:document_type_tcai) if DocumentType.tcai.empty?
    end

    after(:build) do |orientation, evaluator|
      next unless orientation.calendars.empty?

      orientation.calendars = [
        calendar_from_traits.call([evaluator.calendar_period, evaluator.calendar_tcc])
      ]
    end

    after :create do |orientation|
      professor = create(:professor)
      external_member = create(:external_member)
      orientation.professor_supervisors << professor
      orientation.external_member_supervisors << external_member
      orientation.save(validate: false)
    end

    trait :tcc_one do
      calendar_tcc { :tcc_one }
    end

    trait :tcc_two do
      calendar_tcc { :tcc_two }
    end

    trait :current do
      calendar_period { :current }
    end

    trait :previous do
      calendar_period { :previous }
    end

    trait :next do
      calendar_period { :next }
    end

    trait :approved_tcc_one do
      status { Orientation.statuses.key('APPROVED_TCC_ONE') }
    end

    trait :approved do
      status { Orientation.statuses.key('APPROVED') }
    end

    trait :canceled do
      status { Orientation.statuses.key('CANCELED') }
    end

    trait :reproved_tcc_one do
      status { Orientation.statuses.key('REPROVED_TCC_ONE') }
    end

    trait :reproved do
      status { Orientation.statuses.key('REPROVED') }
    end

    trait :with_final_project do
      before(:create) do |orientation, evaluator|
        calendar = if orientation.calendars.empty?
                     calendar_from_traits.call([evaluator.calendar_period, evaluator.calendar_tcc])
                   else
                     orientation.calendars.first
                   end

        activity = create(:activity, :project, calendar:, final_version: true)
        create(:academic_activity, :project, activity:, academic: orientation.academic)
        create(:examination_board, :project, orientation:, situation: :approved)

        orientation.calendars = [calendar]
      end
    end

    trait :with_final_monograph do
      after(:create) do |orientation, evaluator|
        calendar = if orientation.calendars.empty?
                     calendar_from_traits.call([evaluator.calendar_period, evaluator.calendar_tcc])
                   else
                     orientation.calendars.first
                   end

        activity = create(:activity, :monograph, calendar:, final_version: true)
        create(:academic_activity, :monograph, activity:, academic: orientation.academic)
        create(:examination_board, :monograph, orientation:, situation: :approved)

        orientation.calendars = [calendar]
      end
    end

    trait :without_complementary_files do
      after(:create) do |orientation|
        orientation
          .academic_activities
          .joins(:activity)
          .where(activities: { identifier: :monograph })
          .last
          &.update!(complementary_files: nil)
      end
    end

    trait :with_extra_supervisors do
      after(:create) do |orientation|
        orientation.institution = create(:institution) unless orientation.institution

        orientation.professor_supervisors << create(:professor)
        orientation.external_member_supervisors << create(:external_member)
      end
    end
  end
end

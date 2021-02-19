FactoryBot.define do
  factory :orientation do
    title { Faker::Lorem.sentence(word_count: 3) }
    advisor { create(:professor) }
    academic
    institution
    renewal_justification { Faker::Lorem.sentence(word_count: 3) }
    status { Orientation.statuses.key('IN_PROGRESS') }

    before :create do
      create(:document_type_tco) if DocumentType.tco.empty?
      create(:document_type_tcai) if DocumentType.tcai.empty?
    end

    after(:build) do |orientation|
      orientation.calendars << create(:calendar_tcc_one) if orientation.calendars.empty?
    end

    after :create do |orientation|
      professor = create(:professor)
      external_member = create(:external_member)
      orientation.professor_supervisors << professor
      orientation.external_member_supervisors << external_member
      orientation.save
    end

    factory :orientation_tcc_one do
      after(:build) do |orientation|
        orientation.calendars = [create(:calendar_tcc_one)]
      end
    end

    factory :orientation_tcc_two do
      after(:build) do |orientation|
        orientation.calendars = [create(:calendar_tcc_two)]
      end
    end

    factory :current_orientation_tcc_one do
      after(:build) do |orientation|
        orientation.calendars = [create(:current_calendar_tcc_one)]
      end
    end

    factory :current_orientation_tcc_two do
      after(:build) do |orientation|
        orientation.calendars = [create(:current_calendar_tcc_two)]
      end
    end

    factory :previous_orientation_tcc_one do
      after(:build) do |orientation|
        orientation.calendars = [create(:previous_calendar_tcc_one)]
      end
    end

    factory :previous_orientation_tcc_two do
      after(:build) do |orientation|
        orientation.calendars = [create(:previous_calendar_tcc_two)]
      end
    end

    factory :orientation_tcc_one_approved do
      after(:build) do |orientation|
        orientation.calendars = [create(:calendar_tcc_one)]
      end

      status { Orientation.statuses.key('APPROVED') }
    end

    factory :orientation_tcc_two_approved do
      after(:build) do |orientation|
        orientation.calendars = [create(:calendar_tcc_two)]
      end

      status { Orientation.statuses.key('APPROVED') }
    end

    factory :orientation_renewed do
      status { Orientation.statuses.key('RENEWED') }
    end

    factory :orientation_approved do
      status { Orientation.statuses.key('APPROVED') }
    end

    factory :orientation_canceled do
      status { Orientation.statuses.key('CANCELED') }
    end
  end
end

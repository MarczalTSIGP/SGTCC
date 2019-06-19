FactoryBot.define do
  factory :orientation do
    title { Faker::Lorem.sentence(3) }
    advisor { create(:professor) }
    calendar
    academic
    institution
    renewal_justification { Faker::Lorem.sentence(3) }
    status { Orientation.statuses.key('IN_PROGRESS') }

    after :create do |orientation|
      external_member = create(:external_member)
      orientation.external_member_supervisors << external_member
      orientation.save
    end

    factory :orientation_tcc_one do
      calendar { create(:calendar_tcc_one) }
    end

    factory :orientation_tcc_two do
      calendar { create(:calendar_tcc_two) }
    end

    factory :current_orientation_tcc_one do
      calendar { create(:current_calendar_tcc_one) }
    end

    factory :current_orientation_tcc_two do
      calendar { create(:current_calendar_tcc_two) }
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

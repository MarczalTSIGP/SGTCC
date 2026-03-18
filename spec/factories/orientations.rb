FactoryBot.define do
  factory :orientation do
    title { Faker::Lorem.sentence(word_count: 3) }
    advisor { association(:professor) }
    academic
    institution
    renewal_justification { Faker::Lorem.sentence(word_count: 3) }
    status { Orientation.statuses.key('IN_PROGRESS') }

    transient do
      skip_calendar_association { false }
    end

    before :create do
      create(:document_type_tco) if DocumentType.tco.empty?
      create(:document_type_tcai) if DocumentType.tcai.empty?
    end

    after(:build) do |orientation, _evaluator|
      next unless orientation.calendars.empty?

      calendar = find_or_create_calendar(
        year: Calendar.current_year,
        semester: Calendar.current_semester,
        tcc: Calendar.tccs[:one]
      )

      orientation.calendars = [calendar]
    end

    after :create do |orientation|
      professor = create(:professor)
      external_member = create(:external_member)
      orientation.professor_supervisors << professor
      orientation.external_member_supervisors << external_member
      orientation.save(validate: false)
    end

    factory :orientation_tcc_one do
      after(:build) do |orientation|
        orientation.calendars = [
          Calendar.find_or_create_by!(
            year: Calendar.current_year,
            semester: Calendar.current_semester,
            tcc: :one
          )
        ]
      end
    end

    factory :orientation_tcc_two do
      after(:build) do |orientation|
        orientation.calendars = [
          Calendar.find_or_create_by!(
            year: Calendar.current_year,
            semester: Calendar.current_semester,
            tcc: :two
          )
        ]
      end
    end

    factory :current_orientation_tcc_one do
      after(:build) do |orientation|
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:one]
        )

        orientation.calendars = [calendar]
      end
    end

    factory :current_orientation_tcc_two do
      after(:build) do |orientation|
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:two]
        )

        orientation.calendars = [calendar]
      end
    end

    factory :previous_orientation_tcc_one do
      after(:build) do |orientation|
        orientation.calendars = [find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester - 1,
          tcc: Calendar.tccs[:one]
        )]
      end
    end

    factory :previous_orientation_tcc_two do
      after(:build) do |orientation|
        orientation.calendars = [find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester - 1,
          tcc: Calendar.tccs[:two]
        )]
      end
    end

    factory :orientation_tcc_one_approved do
      before(:create) do |orientation|
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:one]
        )
        activity = create(:activity, calendar:, identifier: :project,
                                     final_version: true)
        create(:academic_activity, activity:, academic: orientation.academic)
        create(:examination_board, orientation:, identifier: :project, situation: :approved)
        orientation.calendars = [calendar]
      end

      after(:create) do |orientation|
        professor = create(:professor)
        external_member = create(:external_member)

        orientation.institution = create(:institution) unless orientation.institution

        orientation.professor_supervisors << professor
        orientation.external_member_supervisors << external_member
      end

      status { Orientation.statuses.key('APPROVED_TCC_ONE') }
    end

    factory :orientation_tcc_two_approved do
      after(:create) do |orientation|
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:two]
        )
        activity = create(:activity, calendar:, identifier: :monograph,
                                     final_version: true)
        create(:academic_activity, activity:, academic: orientation.academic)
        create(:examination_board, orientation:, identifier: :monograph,
                                   situation: :approved)

        orientation.calendars = [calendar]
      end

      status { Orientation.statuses.key('APPROVED') }
    end

    factory :orientation_tcc_one_approved_current_calendar do
      before(:create) do |orientation|
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:one]
        )
        activity = create(:activity, calendar:, identifier: :project,
                                     final_version: true)
        create(:academic_activity, activity:, academic: orientation.academic)
        create(:examination_board, orientation:, identifier: :project,
                                   situation: :approved)

        orientation.calendars = [calendar]
      end

      status { Orientation.statuses.key('APPROVED_TCC_ONE') }
    end

    factory :orientation_tcc_one_approved_next_calendar do
      before(:create) do |orientation|
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester + 1, # próximo semestre
          tcc: Calendar.tccs[:one]
        )

        activity = create(:activity, calendar:, identifier: :project,
                                     final_version: true)
        create(:academic_activity, activity:, academic: orientation.academic)
        create(:examination_board, orientation:, identifier: :project,
                                   situation: :approved)

        orientation.calendars = [calendar]
      end

      status { Orientation.statuses.key('APPROVED_TCC_ONE') }
    end

    factory :orientation_tcc_two_approved_no_complementary_files do
      after(:create) do |orientation|
        calendar = find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:two]
        )
        orientation.calendars = [calendar]

        activity = create(:activity, calendar:, identifier: :monograph,
                                     final_version: true)
        create(
          :academic_activity_no_complementary_files,
          activity:,
          academic: orientation.academic
        )
        create(:examination_board, orientation:, identifier: :monograph,
                                   situation: :approved)
      end

      status { Orientation.statuses.key('APPROVED') }
    end

    factory :orientation_approved do
      status { Orientation.statuses.key('APPROVED') }
    end

    factory :orientation_canceled do
      status { Orientation.statuses.key('CANCELED') }
    end

    factory :orientation_reproved do
      status { Orientation.statuses.key('REPROVED') }
    end
  end
end

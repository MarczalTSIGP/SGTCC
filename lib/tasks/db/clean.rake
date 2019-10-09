namespace :db do
  desc 'Clean data'

  task clean: :environment do
    puts 'Cleaning data...'

    [OrientationSupervisor,
     Signature,
     Document,
     DocumentType,
     Meeting,
     ExaminationBoardAttendee,
     ExaminationBoard,
     Orientation,
     AcademicActivity,
     Academic,
     Institution,
     ExternalMember,
     BaseActivity,
     BaseActivityType,
     Activity,
     Calendar,
     Page].each(&:delete_all)

    Professor.where.not(username: 'marczal').destroy_all
  end
end

class Populate::Orientations
  attr_reader :academic_ids, :institution_ids,
              :calendar_ids, :professor_ids, :advisor,
              :supervisors, :external_members, :statuses,
              :index

  def initialize
    @academic_ids = Academic.pluck(:id)
    @institution_ids = Institution.pluck(:id)
    @advisor = Professor.find_by(username: 'marczal')
    @supervisors = Professor.where.not(username: 'marczal')
    @professor_ids = Professor.pluck(:id).first(5)
    @external_members = ExternalMember.all
    @calendars = Calendar.all.reverse
    @statuses = Orientation.statuses.values
    @index = 0
  end

  def populate
    create_approved_orientation(@calendars.first) # tcc one
    create_approved_orientation(@calendars.third) # tcc_one
    create_reproved_orientation(@calendars.third) # tcc_one

    create_approved_in_tcc_one_orientation(@calendars.fifth) # tcc_one
    create_reproved_in_tcc_one_orientation(@calendars.fifth) # tcc_one

    calendar = @calendars[6] # tcc one current semester
    create_in_tcc_one_orientation_with_proposal(calendar) # tcc_one
    create_in_tcc_one_orientation_without_proposal(calendar) # tcc_one

    create_canceled_orientation(calendar)

    sign_orientations
  end

  private

  #
  # Creations
  #--------------------------------------------------------------------------
  def create_in_tcc_one_orientation_with_proposal(calendar)
    4.times do |i|
      orientation = create_orientation(calendar, i)
      add_proposal(orientation)

      next unless i >= 2

      register_document(orientation, 'Envio do Projeto')
      date = examination_board_date(orientation.current_calendar, 'Defesa do Projeto')
      create_examination_board(orientation, :project, date, 100)
    end
  end

  def create_in_tcc_one_orientation_without_proposal(calendar)
    2.times do |i|
      create_orientation(calendar, i)
    end
  end

  def create_approved_in_tcc_one_orientation(calendar)
    4.times do |i|
      orientation = create_orientation(calendar, i)
      add_proposal(orientation)
      add_project(orientation)

      next unless i >= 2

      orientation.reload.migrate

      register_document(orientation, 'Envio da Monografia')
      date = examination_board_date(orientation.current_calendar, 'Defesa da Monografia')
      create_examination_board(orientation, :monograph, date, 100)
    end
  end

  def create_reproved_in_tcc_one_orientation(calendar)
    orientation = create_orientation(calendar, 1)
    add_proposal(orientation, 59)

    orientation = create_orientation(calendar, 1)
    add_proposal(orientation)
    add_project(orientation, 59)
  end

  def create_approved_orientation(calendar)
    4.times do |i|
      orientation = create_orientation(calendar, i)
      add_proposal(orientation)
      add_project(orientation)

      orientation.reload
      orientation.migrate

      add_monograph(orientation)
    end
  end

  def create_reproved_orientation(calendar)
    orientation = create_orientation(calendar, 1)
    add_proposal(orientation)
    add_project(orientation)

    orientation.reload
    orientation.migrate

    add_monograph(orientation, 50)
  end

  def create_canceled_orientation(calendar)
    orientation = create_orientation(calendar, 1)
    add_proposal(orientation)

    orientation.cancel('Cancelled')

    create_tcc_two_canceled_orientation(calendar)
  end

  def create_tcc_two_canceled_orientation(calendar)
    orientation = create_orientation(calendar, 1)
    add_proposal(orientation)
    add_project(orientation)

    orientation.reload
    orientation.migrate
    orientation.cancel('Cancelled')
  end

  #
  # Orientation
  #--------------------------------------------------------------------------
  def create_orientation(calendar, index)
    orientation = Orientation.create!(
      title: "Orientation #{index} - #{calendar.year_with_semester}", calendar_ids: [calendar.id],
      advisor_id: @professor_ids.sample, academic_id: @academic_ids.delete(@academic_ids.sample),
      institution_id: @institution_ids.sample
    )
    add_supervisors(orientation)
    orientation
  end

  def sign_orientations
    orientations = Orientation.last(Orientation.count / 2)
    orientations.each do |orientation|
      orientation.signatures.each(&:sign)
    end
  end

  def add_supervisors(orientation)
    orientation.professor_supervisors << @supervisors.sample
    orientation.external_member_supervisors << @external_members.sample
    orientation.save
  end

  #
  # Proposal
  #--------------------------------------------------------------------------
  def add_proposal(orientation, note = 100)
    calendar = orientation.current_calendar
    register_document(orientation, 'Envio da Proposta')

    date = examination_board_date(calendar, 'Defesa da Proposta')
    create_examination_board(orientation, :proposal, date, note)
    register_document(orientation, 'Envio da Versão Final da Proposta')
  end

  #
  # Project
  #--------------------------------------------------------------------------
  def add_project(orientation, note = 100)
    calendar = orientation.current_calendar
    register_document(orientation, 'Envio do Projeto')

    date = examination_board_date(calendar, 'Defesa do Projeto')
    create_examination_board(orientation, :project, date, note)

    register_document(orientation, 'Envio da Versão Final do Projeto')
  end

  #
  # Monograph
  #--------------------------------------------------------------------------
  def add_monograph(orientation, note = 100)
    calendar = orientation.current_calendar
    register_document(orientation, 'Envio da Monografia')

    date = examination_board_date(calendar, 'Defesa da Monografia')
    create_examination_board(orientation, :monograph, date, note)
    register_document(orientation, 'Envio da Versão Final da Monografia')
  end

  #
  # Send document
  #--------------------------------------------------------------------------
  def register_document(orientation, activity_name)
    calendar = orientation.current_calendar
    ac = calendar.activities.find_by name: activity_name

    file_name = activity_name.split.last.downcase

    ac.academic_activities.create!(
      academic_id: orientation.academic.id,
      title: "#{activity_name} - #{orientation.id} - #{calendar.year_with_semester}",
      summary: Faker::Lorem.paragraph(sentence_count: 10),
      complementary_files: nil, judgment: true, additional_instructions: '# Please read and review',
      pdf: file(file_name)
    )
  end

  #
  # Examination boards
  #--------------------------------------------------------------------------
  def examination_board_date(calendar, activity_name)
    adp = calendar.activities.find_by name: activity_name
    Faker::Time.between(from: adp.initial_date, to: adp.final_date)
  end

  def file(name)
    path = Rails.root.join("app/services/populate/pdfs/#{name}.pdf")
    File.open(path)
  end

  def create_examination_board(orientation, identifier, date, note)
    eb = ExaminationBoard.create(date:, place: 'Lab B7 ou B8',
                                 orientation_id: orientation.id,
                                 tcc: orientation.current_calendar.tcc,
                                 identifier:, document_available_until: date,
                                 professor_ids: professors_evaluators_ids(orientation),
                                 external_member_ids: external_members_evaluators_ids)

    assigning_grades(eb, note)

    document = eb.create_defense_minutes
    document.signatures.each(&:sign)
  end

  def professors_evaluators_ids(orientation)
    Professor.where.not(id: orientation.advisor.id).pluck(:id).sample(2)
  end

  def external_members_evaluators_ids
    ExternalMember.pluck(:id).sample
  end

  def assigning_grades(examination_board, note)
    advisor = examination_board.orientation.advisor
    examination_board.examination_board_notes.create!(professor: advisor, note:)

    assigning_grades_by_professors(examination_board, note)
    assigning_grades_by_external_members(examination_board, note)
  end

  def assigning_grades_by_external_members(examination_board, note)
    examination_board.external_members.each do |external_member|
      examination_board.examination_board_notes.create! external_member:,
                                                        note:,
                                                        appointment_text: '## Rewrite all the text'
    end
  end

  def assigning_grades_by_professors(examination_board, note)
    examination_board.professors.each do |professor|
      examination_board.examination_board_notes.create! professor:,
                                                        note:,
                                                        appointment_text: '## Rewrite all the text'
    end
  end
end

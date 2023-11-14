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
    @calendar_ids = Calendar.pluck(:id)
    @statuses = Orientation.statuses.values
    @index = 0
  end

  def populate
    @calendar_ids.each do |calendar_id|
      10.times do
        create_orientation_by_calendar(calendar_id)
      end
    end
    sign_orientations
  end

  private

  def create_orientation_by_calendar(calendar_id)
    increment_index
    academic_id = @academic_ids.sample
    orientation = Orientation.create!(
      title: "Orientation #{@index}", calendar_ids: [calendar_id],
      advisor_id: @professor_ids.sample, academic_id: academic_id,
      institution_id: @institution_ids.sample, status: @statuses.sample
    )
    add_all(orientation, calendar_id, academic_id)
  end

  def add_all(orientation, calendar_id, academic_id)
    calendars = Calendar.all
    add_supervisors(orientation)
    add_proposal(calendars[-2], orientation, academic_id) if calendars[-2].id == calendar_id
    add_project(calendars[-2], orientation, academic_id) if calendars[-2].id == calendar_id
    add_monograph(calendars[-3], orientation, academic_id) if calendars[-3].id == calendar_id
  end

  def sign_orientations
    orientations = Orientation.last(Orientation.count / 2)
    orientations.each do |orientation|
      orientation.signatures.each(&:sign)
    end
  end

  def increment_index
    @index += 1
  end

  def add_supervisors(orientation)
    orientation.professor_supervisors << @supervisors.sample
    orientation.external_member_supervisors << @external_members.sample
    orientation.save
  end

  def add_proposal(calendar, orientation, academic_id)
    ac = calendar.activities.find_by name: 'Envio da Proposta'
    aa = { academic_id: academic_id, activity_id: ac.id, title: "Proposta do #{academic_id}",
           summary: Faker::Lorem.paragraph(sentence_count: 10),
           complementary_files: nil, judgment: true, additional_instructions: '' }
    create_academic_activity(aa, 'proposta.pdf')
    ac = calendar.activities.find_by name: 'Envio da Versão Final da Proposta'
    create_examination_board(orientation, 'proposal', ac, 100)
    create_final_activity(academic_id, ac, 'proposta.pdf')
  end

  def add_project(calendar, orientation, academic_id)
    ac = calendar.activities.find_by name: 'Envio do Projeto'
    aa = {
      academic_id: academic_id, activity_id: ac.id, title: "Projeto do #{academic_id}",
      summary: Faker::Lorem.paragraph(sentence_count: 10),
      complementary_files: nil, judgment: true, additional_instructions: ''
    }
    create_academic_activity(aa, 'projeto.pdf')
    ac = calendar.activities.find_by name: 'Envio da Versão Final do Projeto'
    create_examination_board(orientation, 'project', ac, 100)
    create_final_activity(academic_id, ac, 'projeto.pdf')
  end

  def add_monograph(calendar, orientation, academic_id)
    ac = calendar.activities.find_by name: 'Envio da Monografia'
    aa = {
      academic_id: academic_id, activity_id: ac.id, title: "Monografia do #{academic_id}",
      summary: Faker::Lorem.paragraph(sentence_count: 10),
      complementary_files: nil, judgment: true, additional_instructions: ''
    }
    create_academic_activity(aa, 'monografia.pdf')
    ac = calendar.activities.find_by name: 'Envio da Versão Final da Monografia'
    create_examination_board(orientation, 'monograph', ac, 100)
    create_final_activity(academic_id, ac, 'monografia.pdf')
  end

  def create_academic_activity(params, pdf_file)
    aa = AcademicActivity.new(params)
    path = Rails.root.join("app/services/populate/pdfs/#{pdf_file}")
    aa.pdf = File.open(path)
    aa.save!
    aa
  end

  def create_final_activity(academic_id, ac_params, pdf_file)
    aa_params = {
      academic_id: academic_id, activity_id: ac_params.id,
      title: "Versão Final #{pdf_file.capitalize} do #{academic_id}",
      summary: Faker::Lorem.paragraph(sentence_count: 10),
      complementary_files: nil, judgment: true, additional_instructions: ''
    }
    create_academic_activity(aa_params, pdf_file)
  end

  def create_examination_board(orientation, identifier, ac_params, note)
    eb_params = {
      date: ac_params.final_date, place: 'Lab B7 ou B8', orientation_id: orientation.id,
      tcc: %w[proposal project].include?(identifier) ? 'one' : 'two',
      identifier: identifier, document_available_until: ac_params.final_date
    }
    evaluator_ids = Professor.pluck(:id).sample(%w[proposal project].include?(identifier) ? 2 : 3)
    eb = add_examination_board_notes(eb_params, note, evaluator_ids, orientation)
    document = eb.create_defense_minutes
    document.signatures.each(&:sign)
  end

  def add_examination_board_notes(eb_params, note, evaluator_ids, orientation)
    eb = ExaminationBoard.new(eb_params)
    eb.professor_ids = evaluator_ids
    eb.save!
    advisor = orientation.advisor
    create_notes(eb, advisor.id, note)
    evaluator_ids.each do |id|
      create_notes(eb, id, note)
    end
    eb
  end

  def create_notes(eb_params, id, note)
    ExaminationBoardNote.create! examination_board_id: eb_params.id,
                                 professor_id: id, external_member_id: nil, note: note
  end
end

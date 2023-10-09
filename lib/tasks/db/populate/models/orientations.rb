module Populate
  class Orientations
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
    end

    def populate
      create_orientation
    end

    private

    def create_orientation
      calendars = Calendar.all
      calendar = calendars[-2] # mudar para pegar primeiro calendario de tcc 1.

      academic_id = @academic_ids.sample

      orientation = Orientation.create!(
        title: "Orientation #{academic_id}",
        calendar_ids: [calendar.id],
        advisor_id: @professor_ids.sample,
        academic_id: academic_id,
        institution_id: @institution_ids.sample
      )

      add_supervisors(orientation)

      orientation.signatures.each(&:sign)

      add_propostal(calendar, orientation, academic_id)
      add_project(calendar, orientation, academic_id)

      calendar = calendars[-3] # próximo calendario de tcc, deve ser o do tcc 2
      orientation.calendars << calendar # adiciona o calendário de tcc 2 para orientação
      add_monograph(calendar, orientation, academic_id)
    end

    def add_supervisors(orientation)
      orientation.professor_supervisors << @supervisors.sample
      orientation.external_member_supervisors << @external_members.sample
      orientation.save
    end

    def add_propostal(calendar, orientation, academic_id)
      ac = calendar.activities.find_by name: 'Envio da Proposta'
      aa = {
        academic_id: academic_id, activity_id: ac.id,
        title: "Proposta do #{academic_id}",
        summary: Faker::Lorem.paragraph(sentence_count: 10),
        complementary_files: nil,
        judgment: true,
        additional_instructions: ''
      }
      aa = AcademicActivity.new(aa)

      path = Rails.root.join('lib/tasks/db/populate/pdfs/proposta.pdf')
      aa.pdf = File.open(path)
      aa.save!

      eb = {
        date: ac.final_date,
        place: 'Lab B7 ou B8', orientation_id: orientation.id,
        tcc: 'one', identifier: 'proposal',
        document_available_until: ac.final_date
      }

      evaluator_ids = Professor.pluck(:id).sample(2)

      eb = ExaminationBoard.new(eb)
      eb.professor_ids = evaluator_ids
      eb.save!

      advisor = orientation.advisor
      ExaminationBoardNote.create! examination_board_id: eb.id,
                                   professor_id: advisor.id, external_member_id: nil,
                                   note: 100

      evaluator_ids.each do |id|
        ExaminationBoardNote.create! examination_board_id: eb.id,
                                     professor_id: id,
                                     external_member_id: nil,
                                     note: 100
      end

      document = eb.create_defense_minutes
      document.signatures.each(&:sign)

      ac = calendar.activities.find_by name: 'Envio da Versão Final da Proposta'
      aa = {
        academic_id: academic_id, activity_id: ac.id,
        title: "Versão Final Proposta do #{academic_id}",
        summary: Faker::Lorem.paragraph(sentence_count: 10),
        complementary_files: nil,
        judgment: true,
        additional_instructions: ''
      }
      aa = AcademicActivity.new(aa)
      path = Rails.root.join('lib/tasks/db/populate/pdfs/proposta.pdf')
      aa.pdf = File.open(path)
      aa.save!
    end

    def add_project(calendar, orientation, academic_id)
      ac = calendar.activities.find_by name: 'Envio do Projeto'
      aa = {
        academic_id: academic_id, activity_id: ac.id,
        title: "Projeto do #{academic_id}",
        summary: Faker::Lorem.paragraph(sentence_count: 10),
        complementary_files: nil,
        judgment: true,
        additional_instructions: ''
      }

      aa = AcademicActivity.new(aa)
      path = Rails.root.join('lib/tasks/db/populate/pdfs/projeto.pdf')
      aa.pdf = File.open(path)
      aa.save!

      eb = {
        date: ac.final_date, place: 'Lab B7 ou B8', orientation_id: orientation.id,
        tcc: 'one', identifier: 'project',
        document_available_until: ac.final_date
      }

      evaluator_ids = Professor.pluck(:id).sample(3)

      eb = ExaminationBoard.new(eb)
      eb.professor_ids = evaluator_ids
      eb.save!

      advisor = orientation.advisor
      ExaminationBoardNote.create! examination_board_id: eb.id,
                                   professor_id: advisor.id, external_member_id: nil,
                                   note: 80

      evaluator_ids.each do |id|
        ExaminationBoardNote.create! examination_board_id: eb.id,
                                     professor_id: id,
                                     external_member_id: nil,
                                     note: 80
      end

      document = eb.create_defense_minutes
      document.signatures.each(&:sign)

      ac = calendar.activities.find_by name: 'Envio da Versão Final do Projeto'
      aa = {
        academic_id: academic_id, activity_id: ac.id,
        title: "Versão Final do Projeto do #{academic_id}",
        summary: Faker::Lorem.paragraph(sentence_count: 10),
        complementary_files: nil,
        judgment: true,
        additional_instructions: ''
      }

      aa = AcademicActivity.new(aa)
      path = Rails.root.join('lib/tasks/db/populate/pdfs/projeto.pdf')
      aa.pdf = File.open(path)
      aa.save!
    end

    def add_monograph(calendar, orientation, academic_id)
      ac = calendar.activities.find_by name: 'Envio da Monografia'
      aa = {
        academic_id: academic_id, activity_id: ac.id,
        title: "Monografia do #{academic_id}",
        summary: Faker::Lorem.paragraph(sentence_count: 10),
        complementary_files: nil,
        judgment: true,
        additional_instructions: ''
      }

      aa = AcademicActivity.new(aa)
      path = Rails.root.join('lib/tasks/db/populate/pdfs/monograph.pdf')
      aa.pdf = File.open(path)
      aa.save!

      eb = {
        date: ac.final_date, place: 'Lab B7 ou B8', orientation_id: orientation.id,
        tcc: 'two', identifier: 'monograph',
        document_available_until: ac.final_date
      }

      evaluator_ids = Professor.pluck(:id).sample(3)

      eb = ExaminationBoard.new(eb)
      eb.professor_ids = evaluator_ids
      eb.save!

      advisor = orientation.advisor
      ExaminationBoardNote.create! examination_board_id: eb.id,
                                   professor_id: advisor.id, external_member_id: nil,
                                   note: 85

      evaluator_ids.each do |id|
        ExaminationBoardNote.create! examination_board_id: eb.id,
                                     professor_id: id,
                                     external_member_id: nil,
                                     note: 85
      end

      document = eb.create_defense_minutes
      document.signatures.each(&:sign)

      ac = calendar.activities.find_by name: 'Envio da Versão Final da Monografia'
      aa = {
        academic_id: academic_id, activity_id: ac.id,
        title: "Versão Final da Monografia do #{academic_id}",
        summary: Faker::Lorem.paragraph(sentence_count: 10),
        complementary_files: nil,
        judgment: true,
        additional_instructions: ''
      }

      aa = AcademicActivity.new(aa)
      path = Rails.root.join('lib/tasks/db/populate/pdfs/monograph.pdf')
      aa.pdf = File.open(path)
      aa.save!
    end
  end
end

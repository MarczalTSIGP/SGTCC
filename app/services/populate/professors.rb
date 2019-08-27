class Populate::Professors
  attr_reader :genders, :professor_type_ids, :scholarity_ids, :roles

  def initialize
    @genders = Professor.genders.values
    @professor_type_ids = ProfessorType.pluck(:id)
    @scholarity_ids = Scholarity.pluck(:id)
    @roles = Role.all
  end

  def populate
    create_professors
  end

  private

  def create_professors
    100.times do |index|
      professor = create_professor(index)
      add_role_to_professor(professor)
    end
  end

  def create_professor(index)
    boolean = Faker::Boolean.boolean

    Professor.create!(
      name: Faker::Name.name, email: "professor#{index}@gmail.com",
      username: "professor#{index}", gender: @genders.sample,
      lattes: "http://lattes.com.#{index}", is_active: boolean,
      available_advisor: boolean, working_area: Faker::Markdown.headers,
      professor_type_id: @professor_type_ids.sample,
      scholarity_id: @scholarity_ids.sample, password: '123456',
      password_confirmation: '123456'
    )
  end

  def add_role_to_professor(professor)
    professor.roles << @roles.sample
    professor.save
  end
end

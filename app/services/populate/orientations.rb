class Populate::Orientations
  attr_reader :academic_ids, :institution_ids, :calendar_ids, :advisor, :professors

  def initialize
    @academic_ids = Academic.pluck(:id)
    @institution_ids = Institution.pluck(:id)
    @advisor = Professor.find_by(username: 'marczal')
    @professors = Professor.where.not(username: 'marczal')
    @calendar_ids = Calendar.pluck(:id)
  end

  def populate
    @calendar_ids.each do |calendar_id|
      10.times do
        create_orientation_by_calendar(calendar_id)
      end
    end
  end

  private

  def create_orientation_by_calendar(calendar_id)
    orientation = Orientation.create(
      title: Faker::Lorem.sentence(3),
      calendar_id: calendar_id,
      advisor_id: @advisor.id,
      academic_id: @academic_ids.sample,
      institution_id: @institution_ids.sample
    )
    orientation.professor_supervisors << @professors.sample
  end
end

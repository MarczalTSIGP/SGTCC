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
    orientation = Orientation.create!(
      title: "Orientation #{@index}",
      calendar_ids: calendar_id,
      advisor_id: @professor_ids.sample,
      academic_id: @academic_ids.sample,
      institution_id: @institution_ids.sample,
      status: @statuses.sample
    )
    add_supervisors(orientation)
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
end

class Logics::Activity::Responses
  def initialize(activity)
    @activity = activity
    @academics_who_responded_ids = @activity.academics.pluck(:id)
    map_academics
  end

  attr_reader :academics

  def total_sent
    @academics_who_responded_ids.size
  end

  def total_should_sent
    all_academics.size
  end

  def entries_info
    return '-' unless @activity.base_activity_type.send_document?

    "#{total_sent} de #{total_should_sent} #{Activity.human_attribute_name(:sent,
                                                                           count: total_sent)}"
  end

  private

  def map_academics
    @academics = all_academics.map do |academic, orientation|
      sent = @academics_who_responded_ids.include?(academic.id)
      Logics::Activity::AcademicResponse.new(academic, sent, orientation)
    end
  end

  def all_academics
    orientation_ids = OrientationCalendar
                      .where(calendar_id: @activity.calendar_id)
                      .pluck(:orientation_id)

    @all_academics ||= Orientation
                       .includes(:academic)
                       .where(id: orientation_ids)
                       .order('academics.name')
                       .map { |orientation| [orientation.academic, orientation] }
  end
end

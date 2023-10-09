class Populate::Meetings
  require 'time'

  attr_reader :orientation_ids

  def initialize
    @orientation_ids = Orientation.pluck(:id)
  end

  def populate
    create_meetings
  end

  private

  def create_meetings
    50.times do
      Meeting.create!(
        content: Faker::Lorem.paragraph,
        date: Time.current,
        orientation_id: @orientation_ids.sample
      )
    end
  end
end

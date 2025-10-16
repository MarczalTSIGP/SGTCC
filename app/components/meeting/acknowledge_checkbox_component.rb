# frozen_string_literal: true

class Meeting::AcknowledgeCheckboxComponent < ViewComponent::Base
  def initialize(meeting:, url:, label: "Dar ciência")
    @meeting = meeting
    @url = url
    @label = label
  end

  def acknowledged?
    @meeting.viewed?
  end
end
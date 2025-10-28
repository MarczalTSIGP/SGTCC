# frozen_string_literal: true

class Forms::DatetimepickerComponent < ViewComponent::Base
  attr_reader :name, :id, :label, :datetime, :disabled

  def initialize(name:, id:, label:, datetime: nil, disabled: false)
    @name = name
    @id = id
    @label = label
    @datetime = datetime
    @disabled = disabled
  end
end

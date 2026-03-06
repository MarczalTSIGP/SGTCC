# frozen_string_literal: true

class Forms::DatetimepickerComponent < ViewComponent::Base
  attr_reader :name, :id, :label, :datetime, :disabled, :errors

  def initialize(name:, id:, label:, **options)
    @name = name
    @id = id
    @label = label
    @datetime = options.fetch(:datetime, nil)
    @disabled = options.fetch(:disabled, false)
    @errors = options.fetch(:errors, []) || []
  end

  def input_class
    base_class = 'form-control'
    return base_class unless errors?

    "#{base_class} is-invalid"
  end

  def errors?
    errors.any?
  end
end

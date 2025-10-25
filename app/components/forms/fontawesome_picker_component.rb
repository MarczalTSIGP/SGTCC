# frozen_string_literal: true

class Forms::FontawesomePickerComponent < ViewComponent::Base
  attr_reader :name, :id, :label, :icon, :errors, :required

  def initialize(name:, id:, label:, options: {})
    @name = name
    @id = id
    @label = label
    @icon = options[:icon]
    @errors = options[:errors] || []
    @required = options.fetch(:required, true)
  end

  def input_class
    base_class = 'form-control'
    return base_class if errors.empty?

    "#{base_class} is-invalid"
  end

  def errors?
    errors.any?
  end
end

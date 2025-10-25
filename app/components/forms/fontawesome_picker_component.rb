# frozen_string_literal: true

class Forms::FontawesomePickerComponent < ViewComponent::Base
  attr_reader :name, :id, :label, :icon, :errors, :required

  def initialize(name:, id:, label:, icon: nil, errors: [], required: true)
    @name = name
    @id = id
    @label = label
    @icon = icon
    @errors = errors
    @required = required
  end

  def input_class
    base_class = 'form-control'
    return base_class if errors.empty?
    
    "#{base_class} is-invalid"
  end

  def has_errors?
    errors.any?
  end
end


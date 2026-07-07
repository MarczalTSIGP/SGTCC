# frozen_string_literal: true

class Forms::DatetimepickerComponent < ViewComponent::Base
  attr_reader :name, :id, :label, :datetime, :disabled, :errors, :enable_time

  def initialize(name:, id:, label:, **options)
    @name = name
    @id = id
    @label = label
    @datetime = options.fetch(:datetime, nil)
    @disabled = options.fetch(:disabled, false)
    @errors = options.fetch(:errors, []) || []
    @enable_time = options.fetch(:enable_time, true)
  end

  def input_class
    base_class = 'form-control'
    return base_class unless errors?

    "#{base_class} is-invalid"
  end

  def errors?
    errors.any?
  end

  def input_format
    enable_time ? '%d/%m/%Y %H:%M' : '%d/%m/%Y'
  end

  def placeholder
    enable_time ? 'DD/MM/YYYY HH:mm' : 'DD/MM/YYYY'
  end

  def maxlength
    enable_time ? 16 : 10
  end

  def pattern
    enable_time ? '\\d{2}/\\d{2}/\\d{4} \\d{2}:\\d{2}' : '\\d{2}/\\d{2}/\\d{4}'
  end

  def field_value
    return if datetime.blank?

    datetime.strftime(input_format)
  end
end

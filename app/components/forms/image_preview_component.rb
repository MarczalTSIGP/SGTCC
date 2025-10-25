# frozen_string_literal: true

class Forms::ImagePreviewComponent < ViewComponent::Base
  attr_reader :resource, :name, :image_url, :image_errors, :form

  def initialize(resource:, name:, image_url: nil, image_errors: [], form: nil)
    @resource = resource
    @name = name
    @image_url = image_url
    @image_errors = image_errors || []
    @form = form
  end

  def input_id
    "#{resource}_#{name}"
  end

  def input_name
    "#{resource}[#{name}]"
  end

  def image?
    image_url.present?
  end

  def errors?
    image_errors.any?
  end

  def error_class
    errors? ? 'is-invalid' : ''
  end
end

# frozen_string_literal: true

class Flash::MessageComponent < ViewComponent::Base
  def initialize(id: nil)
    @id = id || 'flash_messages'
  end

  def messages
    helpers.flash.delete(:timedout)
  end

  def alert_css_classes(flash_type)
    "alert alert-#{class_type(flash_type)} alert-dismissible fade show"
  end

  private

  def class_type(flash_type)
    {
      notice: 'info',
      success: 'success',
      error: 'danger',
      alert: 'warning'
    }[flash_type.to_sym] || 'info'
  end
end

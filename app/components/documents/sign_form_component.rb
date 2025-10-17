# frozen_string_literal: true

class Documents::SignFormComponent < ViewComponent::Base
  include SimpleForm::ActionViewExtensions::FormHelper

  def initialize(username:, confirm_url:, back_url:)
    @username = username
    @confirm_url = confirm_url
    @back_url = back_url
  end
end

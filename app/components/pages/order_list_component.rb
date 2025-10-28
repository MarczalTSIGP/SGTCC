# frozen_string_literal: true

class Pages::OrderListComponent < ViewComponent::Base
  attr_reader :update_sidebar_url, :sidebar_url

  def initialize(update_sidebar_url:, sidebar_url: '/sidebar')
    @update_sidebar_url = update_sidebar_url
    @sidebar_url = sidebar_url
  end
end

class Orientations::Links::BaseService
  private_class_method :new

  attr_accessor :links, :orientation

  def initialize(orientation)
    @route = Rails.application.routes.url_helpers

    @orientation = orientation
    @links = []
    setup_links
  end

  def self.perform(orientation)
    new(orientation).links
  end
end

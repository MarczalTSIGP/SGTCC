class Charts::CardReportNumberComponent < ViewComponent::Base
  def initialize(label:, number:, title:, redirect:, background_color: "default")
    @label = label
    @number = number
    @title = title
    @redirect = redirect
    @background_color = background_color
  end

  private

  attr_reader :label, :number, :title, :redirect, :background_color
end

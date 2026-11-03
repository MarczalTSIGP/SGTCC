# frozen_string_literal: true

class Documents::OrientationTableComponent < ViewComponent::Base
  def initialize(documents:, row_partial:, orientation: nil, show_all_signed: false,
                 actions_colspan: nil)
    @documents = documents
    @row_partial = row_partial
    @orientation = orientation
    @show_all_signed = show_all_signed
    @actions_colspan = actions_colspan
  end

  private

  def show_all_signed?
    @show_all_signed
  end

  def show_actions?
    @actions_colspan.present?
  end
end

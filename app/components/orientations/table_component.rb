# frozen_string_literal: true

class Orientations::TableComponent < ViewComponent::Base
  Badge = Struct.new(:class_name, :label)

  def initialize(orientations:, namespace:, show_legend: true, show_actions: false, action_partial: nil, &action_block)
    @orientations = orientations
    @namespace = namespace
    @show_legend = show_legend
    @show_actions = show_actions
    @action_partial = action_partial
    @action_block = action_block
  end

  def show_path(orientation)
    send("#{@namespace}_orientation_path", orientation)
  end

  def dropdown_links(orientation)
    service_class = "Orientations::Links::#{@namespace.to_s.classify}Service"
    service_class.constantize.perform(orientation)
  end

  def status_badge_html(orientation)
    badge = badge_for_status(orientation.status)
    
    content_tag(
      :span,
      '&nbsp;'.html_safe,
      class: "badge badge-pill #{badge.class_name}",
      data: { controller: 'ui--tooltip' },
      title: badge.label
    )
  end

  def show_legend?
    @show_legend
  end

  def show_actions?
    @show_actions
  end

  def render_action(orientation)
    if @action_partial
      render partial: @action_partial, locals: { orientation: orientation }
    elsif @action_block
      @action_block.call(orientation)
    else
      "<!-- No action configured -->".html_safe
    end
  end

  private

  def badge_for_status(status)
    case Orientation.statuses[status]
    when 'APPROVED_TCC_ONE'
      Badge.new('badge-approved-tcc-1', status)
    when 'APPROVED'
      Badge.new('badge-approved', status)
    when 'IN_PROGRESS'
      Badge.new('badge-in-progress', status)
    when 'CANCELED'
      Badge.new('badge-canceled', status)
    when 'REPROVED_TCC_ONE'
      Badge.new('badge-reproved-tcc-1', status)
    when 'REPROVED'
      Badge.new('badge-reproved', status)
    else
      Badge.new('badge-secondary', status)
    end
  end
end


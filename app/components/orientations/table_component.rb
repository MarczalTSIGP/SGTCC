# frozen_string_literal: true

class Orientations::TableComponent < ViewComponent::Base
  Badge = Struct.new(:class_name, :label)

  def initialize(orientations:, namespace:, **options, &action_block)
    @orientations = orientations
    @namespace = namespace
    @show_legend = options.fetch(:show_legend, true)
    @show_actions = options.fetch(:show_actions, false)
    @action_partial = options[:action_partial]
    @path_helper = options[:path_helper]
    @service_class = options[:service_class]
    @action_block = action_block
  end

  def show_path(orientation)
    if @path_helper
      send(@path_helper, orientation)
    else
      send("#{@namespace}_orientation_path", orientation)
    end
  end

  def dropdown_links(orientation)
    service_class = @service_class || "Orientations::Links::#{service_class_name}Service"
    service_class.constantize.perform(orientation)
  end

  def service_class_name
    case @namespace.to_s
    when 'professors'
      'Professors'
    when 'tcc_one_professors'
      'TccOneProfessors'
    else
      @namespace.to_s.classify
    end
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
      '<!-- No action configured -->'.html_safe
    end
  end

  private

  def badge_for_status(status)
    status_key = Orientation.statuses[status]
    badge_class = status_badge_class(status_key)
    Badge.new(badge_class, status)
  end

  def status_badge_class(status_key)
    status_mappings.fetch(status_key, 'badge-secondary')
  end

  def status_mappings
    {
      'APPROVED_TCC_ONE' => 'badge-approved-tcc-1',
      'APPROVED' => 'badge-approved',
      'IN_PROGRESS' => 'badge-in-progress',
      'CANCELED' => 'badge-canceled',
      'REPROVED_TCC_ONE' => 'badge-reproved-tcc-1',
      'REPROVED' => 'badge-reproved'
    }
  end
end

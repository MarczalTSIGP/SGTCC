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
    @links_presenter = options[:links_presenter]
    @action_block = action_block
  end

  def show_path(orientation)
    if @path_helper
      if @path_helper.respond_to?(:call)
        @path_helper.call(orientation)
      else
        send(@path_helper, orientation)
      end
    else
      send("#{@namespace}_orientation_path", orientation)
    end
  end

  def dropdown_links(orientation)
    links_presenter = @links_presenter || "Orientations::Links::#{links_presenter_name}Presenter"
    links_presenter.constantize.perform(orientation)
  end

  def links_presenter_name
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
    badge_class = Orientations::StatusBadge.class_for(Orientations::StatusBadge.key_for(status))
    Badge.new(badge_class, status)
  end
end

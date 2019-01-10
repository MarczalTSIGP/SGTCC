class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    return '' unless should_render?

    container_tag = @options.fetch(:container_tag, :ol)

    @context.content_tag(:nav, aria: { label: 'breadcrumb' }) do
      @context.content_tag container_tag, class: 'breadcrumb' do
        @elements.collect do |element|
          render_element(element)
        end.join.html_safe
      end
    end
  end

  def render_element(element)
    name = compute_name(element)
    path = compute_path(element)

    current = @context.current_page?(path)

    item_tag = @options.fetch(:tag, :li)

    tag_options =
      if current
        { class: [ 'breadcrumb-item', 'active' ], 'aria-current': 'page' }
      else
        { class: 'breadcrumb-item' }
      end

    @context.content_tag(item_tag, tag_options) do
      @context.link_to_unless_current(name, path, element.options)
    end
  end

  private

  def should_render?
    @elements.any? || @options[:show_empty]
  end
end

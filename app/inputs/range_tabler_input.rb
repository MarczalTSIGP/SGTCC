class RangeTablerInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    value = object.public_send(attribute_name) || merged_input_options[:value] || 0

    @builder.range_field(attribute_name,
                         build_input_options(merged_input_options, value)) + error_html
  end

  def label(_wrapper_options)
    value = object.public_send(attribute_name) || input_html_options[:value] || 0

    template.tag.label(class: 'form-label range-label') do
      template.concat current_note_badge(value)
      template.concat(" | #{I18n.t('views.labels.selected.f')}: ")
      template.concat selected_note_span(value)
    end
  end

  private

  def build_input_options(merged_input_options, value)
    merged_input_options.deep_merge(
      class: input_css_class(merged_input_options[:class]),
      value:,
      min: merged_input_options[:min] || 0,
      max: merged_input_options[:max] || 100,
      data: {
        controller: 'forms--range-tabler',
        action: 'input->forms--range-tabler#update change->forms--range-tabler#update'
      }
    )
  end

  def input_css_class(custom_classes)
    [custom_classes, 'form-control-range', input_error_class].compact.join(' ')
  end

  def current_note_badge(value)
    template.content_tag(
      :span,
      "#{I18n.t('activerecord.attributes.examination_board_note.actual_note')} #{value}",
      class: 'badge bg-blue font-size-13'
    )
  end

  def selected_note_span(value)
    template.tag.span(value, data: { range_tabler_selected_note: true })
  end

  def error_html
    return ''.html_safe unless has_errors?

    template.tag.div(error_text, class: 'invalid-feedback d-block')
  end

  def input_error_class
    'is-invalid' if has_errors?
  end

  def error_text
    object.errors[attribute_name].join(', ')
  end
end

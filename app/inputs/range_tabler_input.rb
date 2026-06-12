class RangeTablerInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    value = object.public_send(attribute_name) || merged_input_options[:value] || 0

    slider_html(merged_input_options, value) + error_html
  end

  def label(_wrapper_options)
    value = object.public_send(attribute_name)

    template.tag.label(class: 'form-label range-label') do
      template.concat summary_card(value)
    end
  end

  private

  def slider_html(merged_input_options, value)
    template.tag.div(class: 'range-slider') do
      template.concat selected_note_output(value)
      template.concat @builder.range_field(
        attribute_name,
        build_input_options(merged_input_options, value)
      )
    end
  end

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
    [custom_classes, 'form-control-range pl-0 pr-0', input_error_class].compact.join(' ')
  end

  def summary_card(value)
    template.tag.div(class: 'range-summary-card') do
      template.concat current_note_card(value)
    end
  end

  def current_note_card(value)
    template.tag.div(class: 'range-summary-item range-summary-item-current') do
      title = note_title(value)
      template.concat summary_title(title)
      template.concat summary_value(value) unless value.nil?
    end
  end

  def note_title(value)
    key = value.nil? ? 'unassigned_note' : 'actual_note'
    I18n.t("activerecord.attributes.examination_board_note.#{key}")
  end

  def summary_title(text)
    template.content_tag(:span, text, class: 'range-summary-title')
  end

  def summary_value(value)
    template.content_tag(:span, value, class: 'range-summary-value')
  end

  def selected_note_output(value)
    template.tag.output(value,
                        class: 'range-selected-value',
                        data: { range_tabler_selected_note: true })
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

class RangeTablerInput < SimpleForm::Inputs::Base

  def input(_wrapper_options)
    default_value = object[attribute_name] || 0
    @builder.range_field(attribute_name, class: 'form-control-range', value: default_value)
  end

  def range_display
    template.tag.span(class: 'range-display') do
      ''
    end
  end

  def label(_wrapper_options)
    default_note =  object.note || 0
    options[:field_name] ||= object.class.human_attribute_name(attribute_name)

    template.tag.label(class: 'form-label range-label') do
      template.concat content_tag(:span, "#{I18n.t('activerecord.attributes.examination_board_note.actual_note')} #{default_note}".html_safe, class: "badge bg-blue bigger-text")
      template.concat(" | Selecionada: ")
      template.concat range_display
    end
  end

end

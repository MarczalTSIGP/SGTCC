class RangeTablerInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    @builder.range_field(attribute_name, class: 'form-control-range', value: object.note, max: 100,
                                         min: 0)
  end

  def range_display
    template.tag.span(class: 'range-display') do
      ''
    end
  end

  def label(_wrapper_options)
    default_note = object.note || 0
    options[:field_name] ||= object.class.human_attribute_name(attribute_name)
    label_text = build_label_text(default_note)
    build_label_markup(label_text)
  end

  private

  def build_label_text(default_note)
    "#{I18n.t('activerecord.attributes.examination_board_note.actual_note')} #{default_note}"
  end

  def build_label_markup(label_text)
    template.tag.label(class: 'form-label range-label') do
      template.concat content_tag(:span, label_text, class: 'badge bg-blue font-size-13')
      template.concat(" | #{I18n.t('views.labels.selected.f')}: ")
      template.concat range_display
    end
  end
end

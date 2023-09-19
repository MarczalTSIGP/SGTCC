class RangeTablerInput < SimpleForm::Inputs::Base

  def input(_wrapper_options)
    @builder.range_field(attribute_name, class: 'form-control-range')
  end

  def range_display
    template.tag.p(class: 'range-display') do
      ''
    end
  end

  def label(_wrapper_options)
    options[:field_name] ||= object.class.human_attribute_name(attribute_name)

    template.tag.label(class: 'form-label range-label') do
      template.concat options[:field_name] + ": " + object.note.to_s
      template.concat range_display
    end
  end

end

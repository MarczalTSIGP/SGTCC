class RangeTablerInput < SimpleForm::Inputs::Base

  def input(_wrapper_options)
    template.concat span_tag
    template.tag.label(class: 'custom-range') do
      template.concat @builder.range_field(attribute_name, class: 'custom-range')
    end
  end

  def span_tag
    options[:field_name] ||= object.class.human_attribute_name(attribute_name)

    template.tag.span(class: 'form-label range-label') do
      options[:field_name]
    end
  end


  def label(_wrapper_options)
    ''
  end

end
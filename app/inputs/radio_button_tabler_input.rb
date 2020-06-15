# <div class="custom-controls-stacked">
#   <div class="form-label">Label</div>
#   <label class="custom-control custom-radio custom-control-inline">
#     <input type="radio" class="custom-control-input">
#     <span class="custom-control-label">Option1</span>
#   </label>
#   <label class="custom-control custom-radio custom-control-inline">
#     <input type="radio" class="custom-control-input">
#     <span class="custom-control-label">Option2</span>
#   </label>
# </div>
class RadioButtonTablerInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    template.tag.div(class: 'custom-controls-stacked') do
      collection = options[:collection].to_a

      concat_tags(collection)
    end
  end

  def div_tag
    template.tag.div(class: 'form-label') do
      options[:field_name] ||= object.class.human_attribute_name(attribute_name)
    end
  end

  def span_tag(title)
    template.tag.span(class: 'custom-control-label') do
      title
    end
  end

  def label_tag(value)
    template.tag.label(class: 'custom-control custom-radio custom-control-inline') do
      template.concat @builder.radio_button(attribute_name, value[1], class: 'custom-control-input')
      template.concat span_tag(value[0])
    end
  end

  def concat_tags(collection)
    template.concat div_tag
    collection.each do |el|
      template.concat label_tag(el)
    end
  end

  def label(_wrapper_options)
    ''
  end
end

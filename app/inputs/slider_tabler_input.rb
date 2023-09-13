class SliderInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      template.content_tag(:div, class: 'slider-container') do

        input_html_options[:type] = 'range'
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
        @builder.input_field(attribute_name, merged_input_options)
  
        template.concat template.content_tag(:span, id: 'nota_display', class: 'nota-display', data: { value: object.public_send(attribute_name) })
  
        # Adicione estilos CSS personalizados aqui
      end
    end
  end
  
# <div>
#   <input id="input_id" type="file" class="custom-file-input">
#   <label class="custom-file-label text-truncate" for"input_id">
#     Procurar arquivo...
#   </label>
#    <small class="form-text text-muted"><%= hint %></small>
# </div>
#
# frozen_string_literal: true

class FileTablerInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    input_id = merged_input_options[:id] || "#{object_name}_#{attribute_name}"

    template.content_tag(:div, class: 'custom-file', data: { controller: 'forms--file-input' }) do
      file_field(input_id, merged_input_options) +
        label_tag(input_id) + error_tag
    end
  end

  private

    def file_field(input_id, options)
      @builder.file_field(attribute_name,
                          options.merge(class: "custom-file-input #{input_error_class}",
                                        id: input_id,
                                        data: { forms__file_input_target: 'input',
                                                action: 'change->forms--file-input#change' }))
    end

    def label_tag(input_id)
      template.content_tag(:label, input_label_text, for: input_id,
                           class: 'custom-file-label text-truncate',
                           data: { forms__file_input_target: 'label' })
    end

    def input_label_text
      extract_cached_filename || options[:label_text] || 'Procurar arquivo...'
    end

    def extract_cached_filename
      File.basename(object.send(attribute_name).path) if object.send(attribute_name).path.present?
    end

    def error_tag
      return ''.html_safe unless has_errors?

      template.content_tag(:div, error_text, class: 'invalid-feedback d-block')
    end

    def input_error_class
      'is-invalid' if has_errors?
    end
end

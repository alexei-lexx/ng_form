module NgForm
  class Builder
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    attr_accessor :model_name

    def initialize(model_name)
      self.model_name = model_name
    end

    def input(attribute, options = {})
      build_text_field(attribute, options)
    end

    private

    def build_text_field(attribute, options)
      if options.has_key?(:label)
        if options[:label]
          label_text = options[:label]
        else
          label_text = nil
        end
      else
        label_text = model_name.to_s.camelize + ' ' + attribute.to_s.camelize
      end
      input_id = "#{model_name}_#{attribute}"

      input_options = {}
      input_options[:type] = options[:as].presence || 'text'
      input_options[:id] = input_id
      input_options['ng-model'] = model_attr(attribute)
      input_options[:class] = 'form-control text'

      content_tag :div, class: 'form-group', 'ng-class' => "{ \"has-error\": #{error_attr(attribute)} }" do
        if label_text
          out = content_tag(:label, label_text, for: input_id)
        else
          out = ''.html_safe
        end

        out + tag(:input, input_options) +
        content_tag(:span, class: 'help-block has-error', 'ng-show' => error_attr(attribute)) do
          "{{#{error_value(attribute)}}}"
        end
      end
    end

    def model_attr(attribute)
      "#{model_name}.#{attribute}"
    end

    def error_attr(attribute)
      "#{model_name}.errors.#{attribute}"
    end

    def error_value(attribute)
      "#{error_attr(attribute)}[0]"
    end
  end
end
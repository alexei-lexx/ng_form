module NgForm
  class Builder
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    attr_accessor :model_name

    def initialize(model_name)
      self.model_name = model_name
    end

    def input(attribute, options = {})
      case options[:as]
      when :text
        build_text_area(attribute, options)
      else
        build_text_field(attribute, options)
      end
    end

    private

    def build_text_field(attribute, options)
      input_options = (options[:input_html] && options[:input_html].dup) || {}
      input_options[:type] = options[:as].presence || 'text'
      input_options[:id] = build_id(attribute, options)
      input_options['ng-model'] = model_attr(attribute)
      input_options[:class] ||= 'form-control text'
      unless input_options.has_key?(:placeholder)
        begin
          input_options[:placeholder] = I18n.t("ng_form.placeholders.#{model_attr(attribute)}", raise: true)
        rescue I18n::MissingTranslationData
          # ignore
        end
        
      end

      content_tag :div, class: 'form-group', 'ng-class' => "{ \"has-error\": #{error_attr(attribute)} }" do
        build_label(attribute, options) + tag(:input, input_options) +
        content_tag(:span, class: 'help-block has-error', 'ng-show' => error_attr(attribute)) do
          "{{#{error_value(attribute)}}}"
        end
      end
    end

    def build_text_area(attribute, options)
      input_id = "#{model_name}_#{attribute}"

      input_options = (options[:input_html] && options[:input_html].dup) || {}
      input_options[:id] ||= input_id
      input_options['ng-model'] = model_attr(attribute)
      input_options[:class] ||= 'form-control text'
      unless input_options.has_key?(:placeholder)
        begin
          input_options[:placeholder] = I18n.t("ng_form.placeholders.#{model_attr(attribute)}", raise: true)
        rescue I18n::MissingTranslationData
          # ignore
        end
        
      end

      content_tag :div, class: 'form-group', 'ng-class' => "{ \"has-error\": #{error_attr(attribute)} }" do
        build_label(attribute, options) + content_tag(:textarea, nil, input_options) +
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

    def build_id(attribute, options)
      if options[:input_html] && options[:input_html].has_key?(:id)
        options[:input_html][:id]
      else
        "#{model_name}_#{attribute}"
      end
    end

    def build_label(attribute, options)
      if options.has_key?(:label)
        text = options[:label]
      else
        begin
          text = I18n.t("ng_form.labels.#{model_attr(attribute)}", raise: true)
        rescue I18n::MissingTranslationData
          text = model_name.to_s.camelize + ' ' + attribute.to_s.camelize
        end
      end

      if text
        content_tag(:label, text, for: build_id(attribute, options))
      else
        ''.html_safe
      end
    end
  end
end
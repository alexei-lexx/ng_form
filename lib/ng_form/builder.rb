module NgForm
  class Builder
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    attr_accessor :model_name

    def initialize(model_name)
      self.model_name = model_name
    end

    def string(attribute, options = {})
      build_text_field(attribute, 'text', options)
    end

    def email(attribute, options = {})
      build_text_field(attribute, 'email', options)
    end

    def text(attribute, options = {})
      input_options = (options[:input_html] && options[:input_html].dup) || {}
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

      build_wrapper attribute do
        build_label(attribute, options) + content_tag(:textarea, nil, input_options) +
        content_tag(:span, class: 'help-block has-error', 'ng-show' => error_attr(attribute)) do
          "{{#{error_value(attribute)}}}"
        end
      end
    end

    def radio_buttons(attribute, collection, options = {})
      input_options = (options[:input_html] && options[:input_html].dup) || {}
      input_options[:id] = build_id(attribute, options)
      input_options[:type] = 'radio'
      input_options[:class] ||= 'radio_buttons'
      input_options[:name] = "#{model_name}[#{attribute}]"
      input_options['ng-model'] = model_attr(attribute)

      build_wrapper attribute, 'radio_buttons' do
        content = ''.html_safe
        collection.each do |item|
          content += content_tag :label, class: 'radio radio-inline' do
            tag(:input, input_options.merge({ value: item })) + item.html_safe
          end
        end
        content
      end
    end

    def select(attribute, collection, options = {})
      input_html = (options[:input_html] && options[:input_html].dup) || {}
      input_html[:id] = build_id(attribute, options)
      input_html[:class] ||= 'select form-control'
      input_html['ng-model'] = model_attr(attribute)
      unless input_html.has_key?(:placeholder)
        begin
          input_html[:placeholder] = I18n.t("ng_form.placeholders.#{model_attr(attribute)}", raise: true)
        rescue I18n::MissingTranslationData
          # ignore
        end
      end

      build_wrapper attribute, 'select' do
        build_label(attribute, options) +
        content_tag(:select, input_html) do
          content = content_tag(:option, '')

          collection.each do |item|
            value = item.respond_to?(:id) ? item.id : item
            if options[:label_method]
              if options[:label_method].is_a?(Symbol)
                label = item.send options[:label_method]
              else
                label = options[:label_method].call(item)
              end
            else
              label = item
            end
            content += content_tag(:option, label, value: value)
          end
          content
        end
      end
    end

    private

    def build_text_field(attribute, type, options)
      input_options = (options[:input_html] && options[:input_html].dup) || {}
      input_options[:type] = type
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

      build_wrapper attribute do
        build_label(attribute, options) + tag(:input, input_options) +
        content_tag(:span, class: 'help-block has-error', 'ng-show' => error_attr(attribute)) do
          "{{#{error_value(attribute)}}}"
        end
      end
    end

    def build_wrapper(attribute, wrapper_class = nil)
      content_tag :div, class: "form-group #{wrapper_class}", 'ng-class' => "{ \"has-error\": #{error_attr(attribute)} }" do
        yield
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
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
      input_html = build_input_html(attribute, options, 'form-control text', true)

      build_wrapper attribute do
        build_label(attribute, options) +
        content_tag(:textarea, nil, input_html) +
        build_error(attribute, options)
      end
    end

    def radio_buttons(attribute, collection, options = {})
      input_html = build_input_html(attribute, options, 'radio_buttons', false)
      input_html[:type] = 'radio'

      build_wrapper attribute, 'radio_buttons' do
        content = ''.html_safe
        collection.each do |item|
          content += content_tag :label, class: 'radio radio-inline' do
            tag(:input, input_html.merge({ value: item })) + item.html_safe
          end
        end
        content + build_error(attribute, options)
      end
    end

    def select(attribute, collection, options = {})
      input_html = build_input_html(attribute, options, 'select form-control', true)

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
        end +
        build_error(attribute, options)
      end
    end

    private

    def build_text_field(attribute, type, options)
      input_html = build_input_html(attribute, options, 'form-control text', true)
      input_html[:type] = type

      build_wrapper attribute do
        build_label(attribute, options) +
        tag(:input, input_html) +
        build_error(attribute, options)
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

    def build_wrapper(attribute, wrapper_class = nil)
      content_tag :div, class: "form-group #{wrapper_class}", 'ng-class' => "{ \"has-error\": #{error_attr(attribute)} }" do
        yield
      end
    end

    def build_input_html(attribute, options, input_class, use_placeholder)
      input_html = (options[:input_html] && options[:input_html].dup) || {}
      input_html[:id] = build_id(attribute, options)
      unless input_html.has_key?('ng-model')
        input_html['ng-model'] = model_attr(attribute)
      end
      unless input_html.has_key?(:class)
        input_html[:class] = input_class
      end
      unless  input_html.has_key?(:name)
        input_html[:name] = "#{model_name}[#{attribute}]"
      end
      if use_placeholder && !input_html.has_key?(:placeholder)
        begin
          input_html[:placeholder] = I18n.t("ng_form.placeholders.#{model_attr(attribute)}", raise: true)
        rescue I18n::MissingTranslationData
          # ignore
        end
      end
      input_html
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
        content_tag(:label, text, class: 'control-label', for: build_id(attribute, options))
      else
        ''.html_safe
      end
    end

    def build_error(attribute, options)
      content_tag(:span, class: 'help-block has-error', 'ng-show' => error_attr(attribute)) do
        "{{#{error_value(attribute)}}}"
      end
    end
  end
end
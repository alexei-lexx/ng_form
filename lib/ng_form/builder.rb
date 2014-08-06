module NgForm
  class Builder
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    attr_accessor :model_name
    attr_accessor :options

    def initialize(model_name, options = {})
      self.model_name = model_name
      self.options = options
    end

    def string(attribute, options = {})
      build_text_field(attribute, 'text', options)
    end

    def email(attribute, options = {})
      build_text_field(attribute, 'email', options)
    end

    def date(attribute, options = {})
      build_text_field(attribute, 'date', options)
    end

    def text(attribute, options = {})
      input_html = build_input_html(attribute, options, 'form-control text', true)

      build_wrapper attribute do
        build_label(attribute, options) +
        content_tag(:textarea, nil, input_html) +
        build_help(attribute, options) +
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
        content + build_help(attribute, options) + build_error(attribute, options)
      end
    end

    def checkbox(attribute, options = {})
      build_wrapper attribute, 'checkbox' do
        content = content_tag :label do
          input_html = build_input_html(attribute, options, nil, false)
          input_html[:type] = 'checkbox'
          tag(:input, input_html) +
          (get_label_text(attribute, options) || '').html_safe
        end
        content + build_help(attribute, options) + build_error(attribute, options)
      end
    end

    def select(attribute, collection, options = {})
      input_html = build_input_html(attribute, options, 'select form-control', true)

      build_wrapper attribute, 'select' do
        build_label(attribute, options) +
        content_tag(:select, input_html) do
          if options[:blank]
            content = content_tag(:option, '')
          else
            content = ''.html_safe
          end

          collection.each do |item|
            if item.is_a? Array
              value = item.first
              label = item.last
            else
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
            end
            
            content += content_tag(:option, label, value: value)
          end
          content
        end +
        build_help(attribute, options) +
        build_error(attribute, options)
      end
    end

    def fields_for(model_name, options = {})
      merged_options = self.options.dup.merge(options)
      builder = NgForm::Builder.new(model_name, merged_options)
      if block_given?
        yield(builder)
      else
        builder
      end
    end

    private

    def build_text_field(attribute, type, options)
      input_html = build_input_html(attribute, options, 'form-control text', true)
      input_html[:type] = type

      build_wrapper attribute do
        build_label(attribute, options) +
        tag(:input, input_html) +
        build_help(attribute, options) +
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
        "#{canonic_model_name}_#{attribute}"
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
        input_html[:name] = "#{canonic_model_name}[#{attribute}]"
      end
      if use_placeholder && !input_html.has_key?(:placeholder)
        begin
          input_html[:placeholder] = t(attribute, 'placeholders')
        rescue I18n::MissingTranslationData
          # ignore
        end
      end
      input_html
    end

    def get_label_text(attribute, options)
      if options.has_key?(:label)
        options[:label]
      else
        begin
          t(attribute, 'labels')
        rescue I18n::MissingTranslationData
          model_name.to_s.camelize + ' ' + attribute.to_s.camelize
        end
      end
    end

    def build_label(attribute, options)
      text = get_label_text(attribute, options)
      if text
        content_tag(:label, text, class: 'control-label', for: build_id(attribute, options))
      else
        ''.html_safe
      end
    end

    def build_error(attribute, options)
      return ''.html_safe if options[:error] == false
      content_tag(:span, class: 'help-block has-error', 'ng-show' => error_attr(attribute)) do
        "{{#{error_value(attribute)}}}"
      end
    end

    def build_help(attribute, options)
      text = nil
      if options.has_key?(:help)
        text = options[:help]
      else
        begin
          text = t(attribute, 'help')
        rescue I18n::MissingTranslationData
          # nothing
        end
      end
      if text
        content_tag :span, class: 'help-block' do
          text
        end
      else
        ''.html_safe
      end
    end

    def t(attribute, what)
      I18n.t("ng_form.#{what}.#{canonic_model_name}.#{attribute}", raise: true)
    end

    def canonic_model_name
      options[:canonic_model_name] || model_name
    end
  end
end
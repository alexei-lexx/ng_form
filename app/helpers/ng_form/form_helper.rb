module NgForm
  module FormHelper
    def ng_form_for(model_name, options = {})
      builder = NgForm::Builder.new(model_name, options)

      form_options = (options[:html] && options[:html].dup) || {}
      form_options[:novalidate] = :novalidate
      if options[:submit]
        form_options['ng-submit'] = options[:submit]
      end

      content_tag(:form, form_options) do
        yield(builder) if block_given?
      end
    end
  end
end
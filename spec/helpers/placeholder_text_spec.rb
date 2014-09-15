require 'spec_helper'

describe 'NgForm::Builder' do
  let(:builder) { NgForm::Builder.new(:user) }

  describe 'Placeholder Text' do
    it 'is set' do
      out = builder.string(:email, input_html: { placeholder: 'Enter e-mail' })

      expect(out).to have_tag(:div) do
        with_tag :input, with: { placeholder: 'Enter e-mail' }
      end
    end

    it 'is taken from locale' do
      I18n.backend.store_translations :en, { 'ng_form' => { placeholders: { user: { email: 'Enter e-mail' } } } }
      out = builder.string(:email)

      expect(out).to have_tag(:div) do
        with_tag :input, with: { placeholder: 'Enter e-mail' }
      end
    end
  end
end
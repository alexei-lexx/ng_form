require 'spec_helper'

describe 'NgForm::Builder' do
  let(:builder) { NgForm::Builder.new(:user) }

  describe 'Label Text' do
    it 'is skipped' do
      out = builder.string(:email, label: false)

      expect(out).to have_tag(:div) do
        without_tag :label
      end
    end

    it 'is custom' do
      out = builder.string(:email, label: 'E-mail address')

      expect(out).to have_tag(:div) do
        with_tag :label, text: 'E-mail address'
      end
    end

    it 'is taken from locale' do
      I18n.backend.store_translations :en, { 'ng_form' => { labels: { user: { email: 'Great e-mail' } } } }
      out = builder.string(:email)

      expect(out).to have_tag(:div) do
        with_tag :label, text: 'Great e-mail'
      end
    end
  end
end
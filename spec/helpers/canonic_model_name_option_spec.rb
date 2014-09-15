require 'spec_helper'

describe NgForm::FormHelper do
  describe 'Option canonic_model_name' do
    let(:builder) { NgForm::Builder.new(:user, canonic_model_name: 'user') }

    it 'is used to get right label translation' do
      I18n.backend.store_translations :en, { 'ng_form' => { labels: { user: { email: 'Great e-mail' } } } }
      out = builder.string :email

      expect(out).to have_tag('label', text: 'Great e-mail')
    end

    it 'is used to generate input[name]' do
      out = builder.string :email
      expect(out).to have_tag('input', with: { name: 'user[email]' })
    end

    it 'is used to generate input[id]' do
      out = builder.string :email
      expect(out).to have_tag('input', with: { id: 'user_email' })
    end
  end
end
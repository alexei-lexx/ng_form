require 'spec_helper'

describe 'NgForm::Builder' do
  before do
    @builder = NgForm::Builder.new(:user)
    I18n.reload!
  end

  it 'creates text field with help text' do
    out = @builder.string(:email, help: 'Use valid e-mail format')

    expect(out).to have_tag(:div) do
      with_tag :span, text: 'Use valid e-mail format', with: { class: 'help-block' }
    end
  end
  
  it 'takes help text from locale' do
    I18n.backend.store_translations :en, { 'ng_form' => { help: { user: { email: 'Use valid e-mail format' } } } }
    out = @builder.string(:email)

    expect(out).to have_tag(:div) do
      with_tag :span, text: 'Use valid e-mail format', with: { class: 'help-block' }
    end
  end
end
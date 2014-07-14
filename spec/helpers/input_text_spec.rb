require 'spec_helper'

describe 'NgForm::Builder' do
  before do
    @builder = NgForm::Builder.new(:user)
    I18n.reload!
  end

  it 'creates text field with label by default' do
    out = @builder.string(:email)

    expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": user.errors.email }' }) do
      with_tag :label, text: 'User Email', with: { for: 'user_email' }
      with_tag :input, with: { class: %w(form-control text), type: 'text', id: 'user_email', 'ng-model' => 'user.email' }
      with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.email' } do
        with_text '{{user.errors.email[0]}}'
      end
    end
  end

  it 'creates text field with custom label' do
    out = @builder.string(:email, label: 'E-mail address')

    expect(out).to have_tag(:div) do
      with_tag :label, text: 'E-mail address'
    end
  end

  it 'creates text field without label' do
    out = @builder.string(:email, label: false)

    expect(out).to have_tag(:div) do
      without_tag :label
    end
  end

  it 'takes label text from locale' do
    I18n.backend.store_translations :en, { 'ng_form' => { labels: { user: { email: 'Great e-mail' } } } }
    out = @builder.string(:email)

    expect(out).to have_tag(:div) do
      with_tag :label, text: 'Great e-mail'
    end
  end

  it 'creates text field with email type' do
    out = @builder.email(:email)

    expect(out).to have_tag(:div) do
      with_tag :input, with: { type: 'email' }
    end
  end

  it 'creates text field with placeholder' do
    out = @builder.string(:email, input_html: { placeholder: 'Enter e-mail' })

    expect(out).to have_tag(:div) do
      with_tag :input, with: { placeholder: 'Enter e-mail' }
    end
  end
  
  it 'takes placeholder text from locale' do
    I18n.backend.store_translations :en, { 'ng_form' => { placeholders: { user: { email: 'Enter e-mail' } } } }
    out = @builder.string(:email)

    expect(out).to have_tag(:div) do
      with_tag :input, with: { placeholder: 'Enter e-mail' }
    end
  end

  it 'creates text field without error text' do
    out = @builder.string(:email, error: false)

    expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": user.errors.email }' }) do
      without_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.email' }
    end
  end
end
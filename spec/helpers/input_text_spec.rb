require 'spec_helper'

describe 'NgForm::Builder' do
  before do
    @builder = NgForm::Builder.new(:user)
  end

  it 'creates text field with label by default' do
    out = @builder.input(:email)

    expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": user.errors.email }' }) do
      with_tag :label, text: 'User Email', with: { for: 'user_email' }
      with_tag :input, with: { class: %w(form-control text), type: 'text', id: 'user_email', 'ng-model' => 'user.email' }
      with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.email' } do
        with_text '{{user.errors.email[0]}}'
      end
    end
  end

  it 'creates text field with custom label' do
    out = @builder.input(:email, label: 'E-mail address')

    expect(out).to have_tag(:div) do
      with_tag :label, text: 'E-mail address'
    end
  end

  it 'creates text field without label' do
    out = @builder.input(:email, label: false)

    expect(out).to have_tag(:div) do
      without_tag :label
    end
  end

  it 'creates text field with email type'
  it 'creates text field with placeholder'
end
require 'spec_helper'

describe 'NgForm::Builder' do
  let(:builder) { NgForm::Builder.new(:user) }

  it 'creates text field' do
    out = builder.string(:email)

    expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": user.errors.email }' }) do
      with_tag :label, text: 'User Email', with: { for: 'user_email' }
      with_tag :input, with: { class: %w(form-control text), type: 'text', id: 'user_email', 'ng-model' => 'user.email' }
      with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.email' } do
        with_text '{{user.errors.email[0]}}'
      end
    end
  end

  it 'creates text field with email type' do
    out = builder.email(:email)

    expect(out).to have_tag(:div) do
      with_tag :input, with: { type: 'email' }
    end
  end

  it 'creates text field without error text' do
    out = builder.string(:email, error: false)

    expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": user.errors.email }' }) do
      without_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.email' }
    end
  end

  it 'uses input type from options arg' do
    out = builder.string(:email, input_html: { type: 'number' })

    expect(out).to have_tag(:div) do
      with_tag :input, with: { type: 'number' }
    end
  end
end
require 'spec_helper'

describe 'NgForm::Builder' do
  let(:builder) { NgForm::Builder.new(:user) }

  it 'creates text area' do
    out = builder.text(:email)

    expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": user.errors.email }' }) do
      with_tag :label, text: 'User Email', with: { for: 'user_email' }
      with_tag :textarea, with: { class: %w(form-control text), id: 'user_email', 'ng-model' => 'user.email' }
      with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.email' } do
        with_text '{{user.errors.email[0]}}'
      end
    end
  end
end
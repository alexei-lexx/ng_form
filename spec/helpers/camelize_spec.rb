require 'spec_helper'

describe 'NgForm::Builder' do
  context 'with camelize is enabled' do
    let(:builder) { NgForm::Builder.new(:user, camelize: true) }

    it 'camelize attributes if enabled' do
      out = builder.string(:first_name)

      expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": user.errors.firstName }' }) do
        with_tag :label, text: 'User First Name', with: { for: 'user_first_name' }
        with_tag :input, with: { class: %w(form-control text), type: 'text', id: 'user_first_name', 'ng-model' => 'user.firstName' }
        with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.firstName' } do
          with_text '{{user.errors.firstName[0]}}'
        end
      end
    end
  end
end
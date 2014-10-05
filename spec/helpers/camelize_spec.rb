require 'spec_helper'

describe 'NgForm::Builder' do
  context 'with enabled camelize option' do
    let(:builder) { NgForm::Builder.new(:new_user, camelize: true) }

    it 'camelizes model and attributes' do
      out = builder.string(:first_name)

      expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": newUser.errors.firstName }' }) do
        with_tag :label, text: 'New User First Name', with: { for: 'new_user_first_name' }
        with_tag :input, with: { class: %w(form-control text), type: 'text', id: 'new_user_first_name', 'ng-model' => 'newUser.firstName' }
        with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'newUser.errors.firstName' } do
          with_text '{{newUser.errors.firstName[0]}}'
        end
      end
    end
  end
end
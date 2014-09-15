require 'spec_helper'

describe 'NgForm::Builder' do
  describe 'Checkbox' do
    let(:builder) { NgForm::Builder.new(:user) }

    it 'is supported' do
      out = builder.checkbox(:active)

      expect(out).to have_tag(:div, with: { class: %w(form-group checkbox), 'ng-class' => '{ "has-error": user.errors.active }' }) do
        with_tag :label do
          with_text 'User Active'
          with_tag :input, with: { type: 'checkbox', name: 'user[active]', 'ng-model' => 'user.active' }
        end
      end
    end
  end
end
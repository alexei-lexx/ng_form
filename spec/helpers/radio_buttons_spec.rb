require 'spec_helper'

describe 'NgForm::Builder' do
  before do
    @builder = NgForm::Builder.new(:user)
  end

  it 'creates radio buttons' do
    out = @builder.radio_buttons(:name, [ 'Tom', 'Jerry' ])

    expect(out).to have_tag(:div, with: { class: %w(form-group radio_buttons), 'ng-class' => '{ "has-error": user.errors.name }' }) do
      with_tag :label, with: { class: %w(radio radio-inline) } do
        with_text 'Tom'
        with_tag :input, with: { type: 'radio', class: 'radio_buttons', name: 'user[name]', 'ng-model' => 'user.name', value: 'Tom' }
      end
      with_tag :label, with: { class: %w(radio radio-inline) } do
        with_text 'Jerry'
        with_tag :input, with: { type: 'radio', class: 'radio_buttons', name: 'user[name]', 'ng-model' => 'user.name', value: 'Jerry' }
      end
    end
  end
end
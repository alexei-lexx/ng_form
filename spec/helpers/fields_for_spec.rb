require 'spec_helper'

describe 'NgForm::Builder' do
  before do
    @builder = NgForm::Builder.new(:user)
    I18n.reload!
  end

  it 'creates text field for nested object' do
    out = @builder.fields_for(:address).string :street

    expect(out).to have_tag(:div, with: { class: 'form-group', 'ng-class' => '{ "has-error": address.errors.street }' }) do
      with_tag :label, text: 'Address Street', with: { for: 'address_street' }
      with_tag :input, with: { class: %w(form-control text), type: 'text', id: 'address_street', 'ng-model' => 'address.street' }
      with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'address.errors.street' } do
        with_text '{{address.errors.street[0]}}'
      end
    end
  end
end
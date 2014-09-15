require 'spec_helper'

describe NgForm::FormHelper do
  it 'is available in views' do
    expect(helper).to respond_to(:ng_form_for)
  end

  it 'creates a form' do
    out = helper.ng_form_for(:user).to_s
    expect(out).to have_tag('form')
  end

  it 'create a form with id' do
    out = helper.ng_form_for(:user, html: { id: 'my-form' }).to_s
    expect(out).to have_tag('form#my-form')
  end

  it 'can have content' do
    out = helper.ng_form_for(:user) do
      'form content'
    end
    expect(out).to have_tag('form') do
      with_text 'form content'
    end
  end

  it 'adds ng-submit directive' do
    out = helper.ng_form_for(:user, submit: 'update(user)')
    expect(out).to have_tag('form', with: { 'ng-submit' => 'update(user)' })
  end
end
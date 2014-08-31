require 'spec_helper'

describe 'NgForm::Builder' do
  let(:builder) { NgForm::Builder.new(:user) }
  before { I18n.reload! }

  it 'creates date field with label by default' do
    out = builder.date(:birthday)

    expect(out).to have_tag(:div) do
      with_tag :input, with: { type: 'date' }
    end
  end
end
require 'spec_helper'

describe 'NgForm::Builder' do
  describe 'Date Input' do
    let(:builder) { NgForm::Builder.new(:user) }

    it 'is supported' do
      out = builder.date(:birthday)

      expect(out).to have_tag(:div) do
        with_tag :input, with: { type: 'date' }
      end
    end
  end
end
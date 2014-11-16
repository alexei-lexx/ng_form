require 'spec_helper'

describe 'NgForm::Builder' do
  describe 'Number Input' do
    let(:builder) { NgForm::Builder.new(:user) }

    it 'is supported' do
      out = builder.number(:birthday)

      expect(out).to have_tag(:div) do
        with_tag :input, with: { type: 'number' }
      end
    end
  end
end
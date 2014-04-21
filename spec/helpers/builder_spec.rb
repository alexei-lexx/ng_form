require 'spec_helper'

describe 'NgForm::Builder' do

  it 'saves model name' do
    builder = NgForm::Builder.new(:post)
    expect(builder.model_name).to eql(:post)
  end
end
require 'spec_helper'

Fruit = Struct.new(:id, :name)

describe 'NgForm::Builder' do
  before do
    @builder = NgForm::Builder.new(:user)
    I18n.reload!
  end

  it 'creates select' do
    out = @builder.select(:role, [ 'Tom', 'Jerry' ])

    expect(out).to have_tag(:div, with: { class: %w(form-group select), 'ng-class' => '{ "has-error": user.errors.role }' }) do
      with_tag :label, text: 'User Role', with: { for: 'user_role' }
      with_tag :select, with: { class: %w(select form-control), 'ng-model' => 'user.role' } do
        with_tag :option, text: 'Tom', with: { value: 'Tom' }
        with_tag :option, text: 'Jerry', with: { value: 'Jerry' }
      end
      with_tag :span, with: { class: %w(help-block has-error), 'ng-show' => 'user.errors.role' } do
        with_text '{{user.errors.role[0]}}'
      end
    end
  end

  it 'creates select from object collection' do
    fruits = [ Fruit.new(1, 'apple'), Fruit.new(2, 'orange') ]
    out = @builder.select :fruit, fruits, label_method: :name

    expect(out).to have_tag(:div) do
      with_tag :select do
        with_tag :option, text: 'apple', with: { value: '1' }
        with_tag :option, text: 'orange', with: { value: '2' }
      end
    end
  end

  it 'creates select where label method is lambda' do
    fruits = [ Fruit.new(1, 'apple'), Fruit.new(2, 'orange') ]
    out = @builder.select :fruit, fruits, label_method: -> (fruit) { fruit.name.upcase }

    expect(out).to have_tag(:div) do
      with_tag :select do
        with_tag :option, text: 'APPLE', with: { value: '1' }
        with_tag :option, text: 'ORANGE', with: { value: '2' }
      end
    end
  end

  it 'creates select with placeholder' do
    out = @builder.select :role, [ 'Tom', 'Jerry' ], input_html: { placeholder: 'Choose a role' }

    expect(out).to have_tag(:div) do
      with_tag :select, with: { placeholder: 'Choose a role' }
    end
  end

  it 'takes placeholder text from locale' do
    I18n.backend.store_translations :en, { 'ng_form' => { placeholders: { user: { role: 'Choose a role' } } } }
    out = @builder.select :role, [ 'Tom', 'Jerry' ]

    expect(out).to have_tag(:div) do
      with_tag :select, with: { placeholder: 'Choose a role' }
    end
  end

  it 'has no blank option by default' do
    out = @builder.select :role, [ 'Tom', 'Jerry' ]

    expect(out).to have_tag(:div) do
      with_tag :select do
        without_tag :option, text: ''
      end
    end
  end

  it 'has blank option if enabled' do
    out = @builder.select :role, [ 'Tom', 'Jerry' ], blank: true

    expect(out).to have_tag(:div) do
      with_tag :select do
        with_tag :option, text: ''
      end
    end
  end

  it 'uses first and last items of option if its an array' do
    out = @builder.select :role, [ [ 't', 'Tom' ], [ 'j', 'Jerry' ] ], blank: true
    expect(out).to have_tag(:div) do
      with_tag :select do
        with_tag :option, text: 'Tom', with: { value: 't' }
        with_tag :option, text: 'Jerry', with: { value: 'j' }
      end
    end
  end
end
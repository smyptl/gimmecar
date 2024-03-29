require 'spec_helper'

describe AfterDateValidator do

  it 'is valid when after date' do
    test_form = Class.new(Lib::Actions::Base) do

      attributes do |a|
        a.date :date
      end

      validates :date,
        after_date: -> { Time.current }
    end

    form = test_form.new({ date: Time.current + 1.day })

    expect(form.valid?).to eq(true)
  end

  it 'creates error when date before validation' do
    test_form = Class.new(Lib::Actions::Base) do

      attributes do |a|
        a.date :date
      end

      validates :date,
        after_date: -> { Time.new(2018, 2, 1, 0, 0, 0, '+00:00')}
    end

    form = test_form.new({ date: Time.new(2018, 1, 31, 0, 0, 0, '-08:00') })

    expect(form.valid?).to eq(false)
    expect(form.errors[:date].count).to eq(1)
  end

  it 'passes unique message' do
    test_form = Class.new(Lib::Actions::Base) do

      attributes do |a|
        a.date :date
      end

      validates :date,
        after_date: { with: -> { Time.current }, message: 'must be after date' }
    end

    form = test_form.new({ date: Time.current - 1.day })

    expect(form.valid?).to eq(false)
    expect(form.errors[:date].count).to eq(1)
    expect(form.errors[:date].first).to eq('must be after date')
  end

  it 'raise ArgumentError if date nil' do
    test_form = Class.new(Lib::Actions::Base) do

      attributes do |a|
        a.date :date
      end

      validates :date,
        after_date: { with: -> { nil }, message: 'must be after date' }
    end

    form = test_form.new({ date: Time.current })

    expect { form.valid? }.to raise_error(ArgumentError)
  end

  it 'does not add error if allow_nil true' do
    test_form = Class.new(Lib::Actions::Base) do

      attributes do |a|
        a.date :date
      end

      validates :date,
        after_date: { with: -> { nil }, allow_nil: true, message: 'must be after date' }
    end

    form = test_form.new({ date: Time.current })

    expect(form.valid?).to eq(true)
  end

  it 'does not add error if value is blank' do
    test_form = Class.new(Lib::Actions::Base) do

      attributes do |a|
        a.date :date
      end

      validates :date,
        after_date: -> { Time.current }
    end

    form = test_form.new

    expect(form.valid?).to eq(true)
  end
end

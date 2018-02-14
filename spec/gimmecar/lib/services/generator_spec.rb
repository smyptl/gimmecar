require 'spec_helper'
require 'factories/drivers'

describe Lib::Services::Generator do

  describe '#fetch' do

    let(:rental) { double(:rental, number: Faker::Number.number(6)) }

    let(:driver) { double(:driver,
                          id: Faker::Number.number(5),
                          name_first: Faker::Name.first_name,
                          name_last: Faker::Name.last_name,
                          name_middle: Faker::Name.last_name,
                          address_2: nil,
                          insurance_policies: [],
                          rentals: [rental],
                          license: nil) }

    it 'returns appropriate hash' do
      rules = Lib::Services::Builder.collection :drivers do |c|
        c.value :name_first
        c.value :name_last, output: -> (d) { d.name_last.upcase }
        c.value :middle_name, as: :name_middle
        c.value :address_2, if: -> (d) { d.address_2.present? }
      end

      results = Lib::Services::Generator.new(klass: nil, rules: rules, query: [driver]).fetch

      expect(results[:object]).to eq(:list)
      expect(results[:count]).to eq(1)
      expect(results[:data].count).to eq(1)

      results_driver = results[:data].first
      expect(results_driver.keys).to eq([:object, :id, :name_first, :name_last, :middle_name])
      expect(results_driver[:name_first]).to eq(driver.name_first)
      expect(results_driver[:name_last]).to eq(driver.name_last.upcase)
      expect(results_driver[:middle_name]).to eq(driver.name_middle)
    end

    it 'returns component hash' do
      output_rules = Lib::Services::Builder
      output_rules.component do |o|
        o.value :name_first
        o.value :middle_name
      end

      rules = Lib::Services::Builder.object(:driver, component: output_rules) do |o|
        o.value :name_last
        o.value :middle_name, output: -> (d) { d.name_middle.upcase }
      end

      results = Lib::Services::Generator.new(klass: nil, rules: rules, query: driver).fetch

      expect(results[:object]).to eq('driver')
      expect(results[:id]).to eq(driver.id)
      expect(results.keys).to eq([:object, :id, :name_first, :middle_name, :name_last])
      expect(results[:name_first]).to eq(driver.name_first)
      expect(results[:name_last]).to eq(driver.name_last)
      expect(results[:middle_name]).to eq(driver.name_middle.upcase)
    end

    it 'if object is nil, returns key with nil value' do
      rules = Lib::Services::Builder.object(:driver) do |o|
        o.object :license do |o|
          o.value :license_number
        end

        o.collection :rentals do |c|
          c.id :number
        end
      end

      results = Lib::Services::Generator.new(klass: nil, rules: rules, query: driver).fetch

      expect(results[:object]).to eq('driver')
      expect(results[:id]).to eq(driver.id)
      expect(results.keys).to eq([:object, :id, :license, :rentals])
      expect(results[:license]).to eq(nil)
      expect(results[:rentals][:data].count).to eq(1)
      expect(results[:rentals][:data].first.keys).to eq([:object, :id])
      expect(results[:rentals][:data].first[:id]).to eq(rental.number)
    end

    it 'uses a method from the klass' do
      rules = Lib::Services::Builder.object(:driver) do |o|
        o.value :can_edit, output: -> (d) { can_edit?(d) }
        o.value :can_destroy, if: -> (d) { can_edit?(d) }
      end

      klass = Class.new do
        def can_edit?(d)
          false
        end
      end

      results = Lib::Services::Generator.new(klass: klass.new, rules: rules, query: driver).fetch

      expect(results[:can_edit]).to eq(false)
      expect(results.keys).to_not include(:can_destroy)
    end
  end
end

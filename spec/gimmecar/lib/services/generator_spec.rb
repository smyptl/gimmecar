require 'spec_helper'
require 'factories/drivers'

describe Lib::Services::Generator do

  describe '#retrieve' do

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

    it 'returns collection hash' do
      rules = Lib::Services::Builder.collection :drivers do |c|
        c.attribute :name_first
        c.attribute :name_last, output: -> (d) { d.name_last.upcase }
        c.attribute :middle_name, as: :name_middle
        c.attribute :address_2, if: -> (d) { d.address_2.present? }
      end

      results = Lib::Services::Generator.new(record: nil, rules: rules, query: [driver]).retrieve

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
        o.attribute :name_first
        o.attribute :middle_name
      end

      rules = Lib::Services::Builder.object(:driver, component: output_rules) do |o|
        o.attribute :name_last
        o.attribute :middle_name, output: -> (d) { d.name_middle.upcase }
      end

      results = Lib::Services::Generator.new(record: nil, rules: rules, query: driver).retrieve

      expect(results[:object]).to eq('driver')
      expect(results[:id]).to eq(driver.id)
      expect(results.keys).to eq([:object, :id, :name_first, :middle_name, :name_last])
      expect(results[:name_first]).to eq(driver.name_first)
      expect(results[:name_last]).to eq(driver.name_last)
      expect(results[:middle_name]).to eq(driver.name_middle.upcase)
    end

    it 'if object is nil, returns key with nil attribute' do
      rules = Lib::Services::Builder.object(:driver) do |o|
        o.object :license do |o|
          o.attribute :license_number
        end

        o.collection :rentals do |c|
          c.id :number
        end
      end

      results = Lib::Services::Generator.new(record: nil, rules: rules, query: driver).retrieve

      expect(results[:object]).to eq('driver')
      expect(results[:id]).to eq(driver.id)
      expect(results.keys).to eq([:object, :id, :license, :rentals])
      expect(results[:license]).to eq(nil)
      expect(results[:rentals][:data].count).to eq(1)
      expect(results[:rentals][:data].first.keys).to eq([:object, :id])
      expect(results[:rentals][:data].first[:id]).to eq(rental.number)
    end

    it 'uses a method from the record' do
      rules = Lib::Services::Builder.object(:driver) do |o|
        o.attribute :can_edit, output: -> (d) { can_edit?(d) }
        o.attribute :can_destroy, if: -> (d) { can_edit?(d) }
      end

      record = Class.new do
        def can_edit?(d)
          false
        end
      end

      results = Lib::Services::Generator.new(record: record.new, rules: rules, query: driver).retrieve

      expect(results[:can_edit]).to eq(false)
      expect(results.keys).to_not include(:can_destroy)
    end

    it 'overrides a previous attribute, can be a string or symbol' do
      rules = Lib::Services::Builder.object(:driver) do |o|
        o.attribute :name_first
        o.attribute 'name_first', output: -> (d) { d.name_first.upcase }
      end

      results = Lib::Services::Generator.new(record: nil, rules: rules, query: driver).retrieve

      expect(results[:name_first]).to eq(driver.name_first.upcase)
    end
  end
end

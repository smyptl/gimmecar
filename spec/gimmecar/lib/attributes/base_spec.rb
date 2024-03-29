require 'spec_helper'

describe Lib::Attributes::Base do

  describe '.define_attribute_read_and_write_methods' do

    let(:test_form) do
      Class.new(Lib::Attributes::Base) do
        attributes do |a|
          a.string :confirmation_number
          a.nested :driver do |d|
            d.string :name_first
            d.string :name_last
            d.nested :insurance do |i|
              i.string :policy_number
            end
          end
          a.nested :promo_codes, array: true do |n|
            n.string :code
          end
          a.integer :ids, array: true
        end
      end
    end

    it 'creates appropriate read write methods' do
      form = test_form.new({ confirmation_number: '12ASDF1' })
      expect(form.confirmation_number).to eq('12ASDF1')

      new_confirmation_number = SecureRandom.hex(4)
      form.confirmation_number =  new_confirmation_number
      expect(form.confirmation_number).to eq(new_confirmation_number)
    end

    it 'creates nested read method, and one write method' do
      form = test_form.new({
        'driver' => {
          'name_first' => 'John',
          'insurance' => {
            'policy_number' => 'ASDF!@#$',
          },
        },
      })

      expect(form.driver_name_first).to eq('John')
      expect(form.driver_insurance).to eq({ 'policy_number' => 'ASDF!@#$' })
      expect(form.driver_insurance_policy_number).to eq('ASDF!@#$')
      expect(form.driver).to eq({
        'name_first' => 'John',
        'insurance'  => {
          'policy_number' => 'ASDF!@#$',
        },
      })
    end

    it 'does not create a read method if nested is array' do
      form = test_form.new({
        promo_codes: []
      })

      expect(form.promo_codes).to eq([])
      expect { form.promo_codes_code }.to raise_error(NoMethodError)
    end

    describe 'array' do
      it 'parses array of attributes correctly' do
        form = test_form.new({
          ids: ['4', :four, 4, nil, '']
        })

        expect(form.ids).to eq([4, 4])
      end

      it 'returns [] if array empty' do
        form = test_form.new({
          ids: nil,
        })

        expect(form.ids).to eq([])
      end
    end
  end
end

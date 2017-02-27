require 'spec_helper'

describe Lib::Forms::Attributes::Base do

  describe '.parse' do
    it 'returns typecasted' do
      a = Lib::Forms::Attributes::Base.new
      a.integer('zip_code')

      expect(Lib::Forms::Attributes::Base.parse('1234', a.fetch[:zip_code])).to eq(1234)
    end

    describe 'array' do
      it 'each item is parsed' do
        a = Lib::Forms::Attributes::Base.new
        a.integer('zip_code', array: true)

        expect(Lib::Forms::Attributes::Base.parse(['1234', '123'], a.fetch[:zip_code])).to eq([1234, 123])
      end

      it 'removes blank items' do
        a = Lib::Forms::Attributes::Base.new
        a.integer('zip_code', array: true)

        expect(Lib::Forms::Attributes::Base.parse(['1234', ''], a.fetch[:zip_code])).to eq([1234])
      end
    end

    it '.parse_nested'
  end

  it '#string' do
    a = Lib::Forms::Attributes::Base.new
    a.string('email')

    expect(a.fetch).to eq({ "email" => { "type"=>:string, "options"=>{} } })
  end
end

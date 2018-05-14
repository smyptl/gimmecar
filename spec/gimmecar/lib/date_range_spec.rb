require 'spec_helper'

describe Lib::DateRange do

  describe '#days_apart' do
    context 'different time zone' do
      it 'two days apart' do
        date_range = Lib::DateRange.new(Time.parse('2018-05-13T17:31:11+00:00'), Time.parse('2018-05-15T10:31:11-07:00'))
        expect(date_range.days_apart).to eq(2)
      end
    end
  end

  #describe "#include?" do
    #let(:date_range) { Lib::DateRange.new(Date.new(2000,1,1), Date.new(2001,1,1)) }

    #it "date before start_date" do
      #expect(date_range.include?(Date.new(1999,1,1))).to eq(false)
    #end

    #it "date after end_date" do
      #expect(date_range.include?(Date.new(2002,1,1))).to eq(false)
    #end

    #it "date on start_date" do
      #expect(date_range.include?(Date.new(2000,1,1))).to eq(true)
    #end

    #it "date on end_date" do
      #expect(date_range.include?(Date.new(2001,1,1))).to eq(true)
    #end

    #it "date is between start_end and end_date" do
      #expect(date_range.include?(Date.new(2000,6,1))).to eq(true)
    #end
  #end
end

require "spec_helper"

describe Lib::TypeCast::Date do
  describe ".type_cast" do
    context "standard string date" do
      it "value is random string" do
        expect(Lib::TypeCast::Date.type_cast("Testing")).to eq(nil)
      end

      it "value is date in string" do
        expect(Lib::TypeCast::Date.type_cast("1/01/2001")).to eq(Date.new(2001,1,1))
      end

      it "value is Date object" do
        expect(Lib::TypeCast::Date.type_cast(Date.new(2001,1,1))).to eq(Date.new(2001,1,1))
      end

      it "is in wrong format" do
        expect(Lib::TypeCast::Date.type_cast("1/6/2000")).to_not eq(Date.new(2000,6,1))
      end

      it "value is invalid date" do
        expect(Lib::TypeCast::Date.type_cast("02/31/2000")).to eq(nil)
      end

      it "value is invalid date format" do
        expect(Lib::TypeCast::Date.type_cast("1/18/90")).to eq(nil)
      end
    end

    context "json date" do
      it "valid test 1" do
        expect(Lib::TypeCast::Date.type_cast("2011-12-31T23:59:59+00:00")).to eq(Date.new(2011,12,31))
      end

      it "valid test 2" do
        expect(Lib::TypeCast::Date.type_cast("2001-09-01T07:00:00.000Z")).to eq(Date.new(2001, 9, 1))
      end

      it "invalid" do
        expect(Lib::TypeCast::Date.type_cast("2001-09-41T07:00:00.000Z")).to eq(nil)
      end
    end
  end
end

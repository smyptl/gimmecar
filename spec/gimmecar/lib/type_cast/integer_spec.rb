require "spec_helper"

describe Lib::TypeCast::Integer do
  describe ".type_cast" do
    it "value is random string" do
      expect(Lib::TypeCast::Integer.type_cast("Testing")).to eq(nil)
    end

    it "value is number in string" do
      expect(Lib::TypeCast::Integer.type_cast("123")).to eq(123)
    end

    it "value is a negative string" do
      expect(Lib::TypeCast::Integer.type_cast("-123")).to eq(123)
    end

    it "value is contains number" do
      expect(Lib::TypeCast::Integer.type_cast("123x")).to eq(123)
    end

    it "value is number in integer" do
      expect(Lib::TypeCast::Integer.type_cast(123)).to eq(123)
    end

    it "value is a negative number" do
      expect(Lib::TypeCast::Integer.type_cast(-123)).to eq(-123)
    end
  end
end

require "spec_helper"

describe Lib::TypeCast::Boolean do
  describe ".type_cast" do
    it "value is a string" do
      expect(Lib::TypeCast::Boolean.type_cast("false     ")).to eq(false)
    end

    it "value is empty string" do
      expect(Lib::TypeCast::Boolean.type_cast("     ")).to eq(false)
    end

    it "value is blank" do
      expect(Lib::TypeCast::Boolean.type_cast("")).to eq(false)
    end

    it "value is a true" do
      expect(Lib::TypeCast::Boolean.type_cast(true)).to eq(true)
    end

    it "value is a false" do
      expect(Lib::TypeCast::Boolean.type_cast(false)).to eq(false)
    end

    describe "value is an integer" do
      it "is one" do
        expect(Lib::TypeCast::Boolean.type_cast(1)).to eq(true)
      end

      it "is other than one" do
        expect(Lib::TypeCast::Boolean.type_cast(678)).to eq(false)
      end
    end

    it "value is nil" do
      expect(Lib::TypeCast::Boolean.type_cast(nil)).to eq(false)
    end
  end
end

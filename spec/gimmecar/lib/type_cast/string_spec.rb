require "spec_helper"

describe Lib::TypeCast::String do
  describe ".type_cast" do
    it "converts to a string" do
      expect(Lib::TypeCast::String.type_cast(false)).to eq("false")
    end

    it "strips away white space" do
      expect(Lib::TypeCast::String.type_cast("  test  ")).to eq("test")
    end

    it "blank string outputs nil" do
      expect(Lib::TypeCast::String.type_cast("    ")).to eq(nil)
    end
  end
end

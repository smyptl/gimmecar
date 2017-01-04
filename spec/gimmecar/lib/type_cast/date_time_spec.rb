require "spec_helper"

describe Lib::TypeCast::DateTime do
  describe ".type_cast" do
    context "standard string time" do
      it "value is random string" do
        expect(Lib::TypeCast::DateTime.type_cast("ASDF")).to eq(nil)
      end

      it "value has wrong date" do
        expect(Lib::TypeCast::DateTime.type_cast('2017-01-34T11:10:51-08:00')).to eq(nil)
      end

      it "value has wrong time" do
        expect(Lib::TypeCast::DateTime.type_cast('2017-01-04T41:10:51-08:00')).to eq(nil)
      end

      it "value is date and time are valid in string" do
        expect(Lib::TypeCast::DateTime.type_cast('2017-01-04T11:10:51-08:00')).to eq(DateTime.new(2017, 1, 4, 11, 10, 51, "-8"))
      end

      it "value is date and time are valid in string" do
        expect(Lib::TypeCast::DateTime.type_cast("2001-09-01T07:00:00.000Z")).to eq(DateTime.new(2001, 9, 1, 7, 0, 0, "0"))
      end

      it "value is DateTime object" do
        expect(Lib::TypeCast::DateTime.type_cast(DateTime.new(2001,1,1))).to eq(DateTime.new(2001,1,1))
      end
    end
  end
end

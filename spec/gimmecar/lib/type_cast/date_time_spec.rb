require "spec_helper"

describe Lib::TypeCast::DateTime do
  describe ".type_cast" do
    context "standard string time" do
      it "value is random string" do
        expect(Lib::TypeCast::DateTime.type_cast("ASDF")).to eq(nil)
      end

      it "value has wrong date" do
        expect(Lib::TypeCast::DateTime.type_cast({ :date => "asdf", :time => "3:00 PM" })).to eq(nil)
      end

      it "value has wrong time" do
        expect(Lib::TypeCast::DateTime.type_cast({ :date => "1/1/2012", :time => "Asdf" })).to eq(nil)
      end

      it "value is date and time are valid in string" do
        expect(Lib::TypeCast::DateTime.type_cast({ :date => "1/1/2012", :time => "2:00 PM" })).to eq(DateTime.new(2012, 1, 1, 14, 0, 0, "-8"))
      end

      it "value is DateTime object" do
        expect(Lib::TypeCast::DateTime.type_cast(DateTime.new(2001,1,1))).to eq(DateTime.new(2001,1,1))
      end
    end
  end
end

require 'spec_helper'

describe Lib::Attributes::TypeCast do
  describe ".boolean" do
    it "value is a string" do
      expect(Lib::Attributes::TypeCast.boolean("false     ")).to eq(false)
    end

    it "value is empty string" do
      expect(Lib::Attributes::TypeCast.boolean("     ")).to eq(false)
    end

    it "value is blank" do
      expect(Lib::Attributes::TypeCast.boolean("")).to eq(false)
    end

    it "value is a true" do
      expect(Lib::Attributes::TypeCast.boolean(true)).to eq(true)
    end

    it "value is a false" do
      expect(Lib::Attributes::TypeCast.boolean(false)).to eq(false)
    end

    describe "value is an integer" do
      it "is one" do
        expect(Lib::Attributes::TypeCast.boolean(1)).to eq(true)
      end

      it "is other than one" do
        expect(Lib::Attributes::TypeCast.boolean(678)).to eq(false)
      end
    end

    it "value is nil" do
      expect(Lib::Attributes::TypeCast.boolean(nil)).to eq(false)
    end
  end

  describe ".date" do
    context "standard string date" do
      it "value is random string" do
        expect(Lib::Attributes::TypeCast.date("Testing")).to eq(nil)
      end

      it "value is date in string" do
        expect(Lib::Attributes::TypeCast.date("1/01/2001")).to eq(Date.new(2001,1,1))
      end

      it "value is Date object" do
        expect(Lib::Attributes::TypeCast.date(Date.new(2001,1,1))).to eq(Date.new(2001,1,1))
      end

      it "is in wrong format" do
        expect(Lib::Attributes::TypeCast.date("1/6/2000")).to_not eq(Date.new(2000,6,1))
      end

      it "value is invalid date" do
        expect(Lib::Attributes::TypeCast.date("02/31/2000")).to eq(nil)
      end

      it "value is invalid date format" do
        expect(Lib::Attributes::TypeCast.date("1/18/90")).to eq(nil)
      end
    end

    context "json date" do
      it "valid test 1" do
        expect(Lib::Attributes::TypeCast.date("2011-12-31T23:59:59+00:00")).to eq(Date.new(2011,12,31))
      end

      it "valid test 2" do
        expect(Lib::Attributes::TypeCast.date("2001-09-01T07:00:00.000Z")).to eq(Date.new(2001, 9, 1))
      end

      it "invalid" do
        expect(Lib::Attributes::TypeCast.date("2001-09-41T07:00:00.000Z")).to eq(nil)
      end
    end
  end

  describe ".time" do
    context "standard string time" do
      it "value is random string" do
        expect(Lib::Attributes::TypeCast.time("ASDF")).to eq(nil)
      end

      it "value has wrong date" do
        expect(Lib::Attributes::TypeCast.time('2017-01-34T11:10:51-08:00')).to eq(nil)
      end

      it "value has wrong time" do
        expect(Lib::Attributes::TypeCast.time('2017-01-04T41:10:51-08:00')).to eq(nil)
      end

      it "value is date and time are valid in string" do
        expect(Lib::Attributes::TypeCast.time('2017-01-04T11:10:51-08:00')).to eq(Time.new(2017, 1, 4, 11, 10, 51, '-08:00'))
      end

      it "value is date and time are valid in string" do
        expect(Lib::Attributes::TypeCast.time("2001-09-01T07:00:00.000Z")).to eq(Time.new(2001, 9, 1, 7, 0, 0, '-00:00'))
      end

      it "value is Time object" do
        expect(Lib::Attributes::TypeCast.time(Time.new(2001,1,1))).to eq(Time.new(2001,1,1))
      end
    end
  end

  describe ".integer" do
    it "value is random string" do
      expect(Lib::Attributes::TypeCast.integer("Testing")).to eq(nil)
    end

    it "value is number in string" do
      expect(Lib::Attributes::TypeCast.integer("123")).to eq(123)
    end

    it "value is a negative string" do
      expect(Lib::Attributes::TypeCast.integer("-123")).to eq(123)
    end

    it "value is contains number" do
      expect(Lib::Attributes::TypeCast.integer("123x")).to eq(123)
    end

    it "value is number in integer" do
      expect(Lib::Attributes::TypeCast.integer(123)).to eq(123)
    end

    it "value is a negative number" do
      expect(Lib::Attributes::TypeCast.integer(-123)).to eq(-123)
    end
  end

  describe ".string" do
    it "converts to a string" do
      expect(Lib::Attributes::TypeCast.string(false)).to eq("false")
    end

    it "strips away white space" do
      expect(Lib::Attributes::TypeCast.string("  test  ")).to eq("test")
    end

    it "blank string outputs nil" do
      expect(Lib::Attributes::TypeCast.string("    ")).to eq(nil)
    end
  end
end

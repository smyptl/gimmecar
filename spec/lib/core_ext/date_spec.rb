require "spec_helper"

describe "Date" do
  describe "#before?" do
    let(:date) { Date.new(2000,1,1) }
    it "it is before date" do
      expect(date.before?(Date.new(1999, 1, 1))).to eq(false)
    end

    it "it is after date" do
      expect(date.before?(Date.new(2001, 1, 1))).to eq(true)
    end

    it "it is the same date" do
      expect(date.before?(Date.new(2000, 1, 1))).to eq(false)
    end
  end

  describe "#after?" do
    let(:date) { Date.new(2000, 1, 1) }

    it "it is before date" do
      expect(date.after?(Date.new(1999, 1, 1))).to eq(true)
    end

    it "it is after date" do
      expect(date.after?(Date.new(2001, 1, 1))).to eq(false)
    end

    it "it is the same date" do
      expect(date.after?(Date.new(2000, 1, 1))).to eq(false)
    end
  end
end

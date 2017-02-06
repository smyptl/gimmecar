require "spec_helper"

describe Logic::CalculateRental do

  describe "#rates" do

    it "returns array of rates for each day" do
      rental_period = Lib::DateRange.new(DateTime.new(2011, 1, 1), DateTime.new(2011, 1, 4))
      rental = double(:rental, :rental_period => rental_period)

      l = Logic::CalculateRental.new(rental)
      expect(l.rates).to eq([
        {
          value: 3500,
          date: Date.new(2011, 1, 1)
        },
        {
          value: 3500,
          date: Date.new(2011, 1, 2)
        },
        {
          value: 3500,
          date: Date.new(2011, 1, 3)
        }
      ])
    end

    describe "partial day" do
      it "returns full value if greater than 2 hours" do
        rental_period = Lib::DateRange.new(DateTime.new(2011, 1, 1, 4, 0, 0), DateTime.new(2011, 1, 2, 7, 0, 0))
        rental = double(:rental, :rental_period => rental_period)

        l = Logic::CalculateRental.new(rental)

        expect(l.rates).to eq([
          {
            value: 3500,
            date: DateTime.new(2011, 1, 1, 4, 0, 0)
          },
          {
            value: 3500,
            date: DateTime.new(2011, 1, 2, 4, 0, 0)
          },
        ])
      end

      it "returns parital value if less than 3 hours" do
        rental_period = Lib::DateRange.new(DateTime.new(2011, 1, 1, 4, 0, 0), DateTime.new(2011, 1, 2, 6, 0, 0))
        rental = double(:rental, :rental_period => rental_period)

        l = Logic::CalculateRental.new(rental)

        expect(l.rates).to eq([
          {
            value: 3500,
            date: DateTime.new(2011, 1, 1, 4, 0, 0)
          },
          {
            value: 2334,
            date: DateTime.new(2011, 1, 2, 4, 0, 0)
          },
        ])
      end

      it 'returns last date for partial if rental is greater than 24 hours' do
        rental_period = Lib::DateRange.new(DateTime.new(2011, 1, 1, 3, 0, 0), DateTime.new(2011, 1, 3, 4, 0, 0))
        rental = double(:rental, :rental_period => rental_period)

        l = Logic::CalculateRental.new(rental)

        expect(l.rates).to eq([
          {
            value: 3500,
            date: DateTime.new(2011, 1, 1, 3, 0, 0)
          },
          {
            value: 3500,
            date: DateTime.new(2011, 1, 2, 3, 0, 0)
          },
          {
            value: 1167,
            date: DateTime.new(2011, 1, 3, 3, 0, 0)
          },
        ])
      end

      it 'actual example' do
        rental_period = Lib::DateRange.new(DateTime.new(2017, 1, 31, 10, 57, 0), DateTime.new(2017, 2, 5, 9, 57, 0))
        rental = double(:rental, :rental_period => rental_period)

        l = Logic::CalculateRental.new(rental)

        expect(l.rates).to eq([
          {
            value: 3500,
            date: DateTime.new(2017, 1, 31, 10, 57, 0)
          },
          {
            value: 3500,
            date: DateTime.new(2017, 2, 1, 10, 57, 0)
          },
          {
            value: 3500,
            date: DateTime.new(2017, 2, 2, 10, 57, 0)
          },
          {
            value: 3500,
            date: DateTime.new(2017, 2, 3, 10, 57, 0)
          },
          {
            value: 3500,
            date: DateTime.new(2017, 2, 4, 10, 57, 0)
          },
        ])
    end
    end
  end

  describe "#tax" do
    it "returns the rate times 8.0% sales tax" do
      rental_period = Lib::DateRange.new(DateTime.new(2011, 1, 1), DateTime.new(2011, 1, 4))
      rental = double(:rental, :rental_period => rental_period)

      expect(Logic::CalculateRental.new(rental).tax).to eq({ :value => 840, :rate => 0.08 })
    end
  end
end

class Services::Command::Rental::ReturnDeposit < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attribute :deposit_amount
    end
  end

  def query
    Rental.include(:deposit).find_by(number: number)
  end
end

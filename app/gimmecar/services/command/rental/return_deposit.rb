class Services::Command::Rental::ReturnDeposit < Lib::Services::Base

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attribute :deposit_amount
    end
  end

  def query
    Rental.includes(:deposit).find_by(number: number)
  end
end

class Actions::Admin::Vehicles::ChangeStatus < Lib::Actions::Base

  attributes do |a|
    a.string :status
  end

  validates :status,
    inclusion: { in: Vehicle::STATUS, message: 'Select a valid status.' }

  def save
    Vehicle.find_by(vin: @params.fetch(:vin)).update(status: status)
  end

  def success_args
    {
      message: 'Vehicle status changed.'
    }
  end
end

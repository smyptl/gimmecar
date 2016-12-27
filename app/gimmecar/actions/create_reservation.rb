class Actions::CreateReservation < Lib::Forms::Base

  attribute :pickup,       :date_time
  attribute :drop_off,     :date_time

  attribute :first_name,   :string
  attribute :last_name,    :string
  attribute :email,        :string
  attribute :phone_number, :integer

  private

  def success_args
  end

  def failure_args
  end

  def save
  end
end

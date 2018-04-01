class Command::Rentals::ReceiptController < Command::Rentals::BaseController

  def print
    Services::Command::Rental::Print.new(number: number).retrieve(success, failure)
  end

  private

  def render_layout
    render 'command/receipt'
  end
end

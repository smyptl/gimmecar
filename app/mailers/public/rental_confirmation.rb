class Public::RentalConfirmation < ApplicationMailer

  def customer(email)
    @email = email
    mail(to: email.fetch(:email),
         subject: "GimmeCar Rental Confirmation",
         content_type: "text/html",
         template_path: "public/emails")
  end

  def samay(email)
    @email = email
    mail(to: 'samay@gimmecar.com, gm@super8redlands.com',
         subject: "GimmeCar - New Reservation!",
         content_type: "text/html",
         template_path: "public/emails")
  end
end

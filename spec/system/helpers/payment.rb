require 'helpers/stripe_helper'

def fill_in_payment(number: CARD_TYPE[:visa], expiration_date: '01/20', cvc: '123', zip_code: '90210')
  stripe_iframe = all('iframe[name=__privateStripeFrame5]').last
  Capybara.within_frame stripe_iframe do
    find('input[name=cardnumber]').set(number)
    find('input[name="exp-date"]').set(expiration_date)
    find('input[name="cvc"]').set(cvc)
    find('input[name="postal"]').set(zip_code)
  end
end

CARD_TYPE = {
  :visa    => '4242424242424242',
  :prepaid => '5105105105105100',
}

def create_valid_credit_card_token_id(card_type = :visa)
  number = CARD_TYPE[card_type]

  Stripe::Token.create({
    :card => {
      :number    => number,
      :exp_month => 2,
      :exp_year  => 2018,
      :cvc       => '314',
    },
  })['id']
end

INVALID_CREDIT_CARD_REASONS = {
  :zip_code         => '4000000000000036',
  :cvc              => '4000000000000101',
  :declined         => '4000000000000002',
  :expired          => '4000000000000069',
  :processing_error => '4000000000000119',
  :charge_failure   => '4000000000000341',
}

def create_invalid_credit_card_token_id(reason)
  number = INVALID_CREDIT_CARD_REASONS[reason]

  Stripe::Token.create({
    :card => {
      :number => number,
      :exp_month => 2,
      :exp_year => 2018,
      :cvc => '314',
    },
  })['id']
end

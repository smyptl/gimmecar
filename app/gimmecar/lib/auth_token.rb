class Lib::AuthToken

  attr_reader :token
  attr_reader :payload

  SIGNATURE_ALGORITHM = 'HS256'
  SECRET_KEY          = -> { Rails.application.secrets.secret_key_base }

  TOKEN_AUDIENCE      = nil
  VERIFY_AUDIENCE     = false

  TOKEN_LIFETIME      = 2.day
  VERIFY_EXPIRATION   = true

  def self.issue(payload)
    claims = {
      :exp => TOKEN_LIFETIME.from_now.to_i,
      :aud => TOKEN_AUDIENCE,
    }

    payload = claims.merge(payload)

    JWT.encode(payload, SECRET_KEY.call, SIGNATURE_ALGORITHM)
  end

  def self.authenticate(token)
    options = {
      :algorithm         => SIGNATURE_ALGORITHM,
      :aud               => TOKEN_AUDIENCE,
      :verify_aud        => VERIFY_AUDIENCE,
      :verify_expiration => VERIFY_EXPIRATION,
    }

    payload, _ = JWT.decode(token, SECRET_KEY.call, true, options)

    payload
  end
end

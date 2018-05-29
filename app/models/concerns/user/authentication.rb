module Concerns::User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password

    validates :first_name, :last_name,
      presence: true

    validates :email, uniqueness: true, presence: true
  end

  class_methods do
    def authenticate_by_token(token, command: false)
      payload = Lib::AuthToken.authenticate(token)

      user = find_by({
        id:                payload.fetch('sub'),
        email:             payload.fetch('email'),
        persistence_token: payload.fetch('persistence_token')
      })

      if command
        user && user.command? ? user : nil
      else
        user
      end
    end
  end

  def command?
    if Rails.env.production?
      ['samay@gimmecar.com', 'jay@gimmecar.com'].include?(email)
    else
      true
    end
  end

  def issue_token
    reset_persistence_token

    Lib::AuthToken.issue({
      sub:               id,
      email:             email,
      persistence_token: persistence_token,
    })
  end

  private

  def reset_persistence_token
    update(persistence_token: SecureRandom.uuid)
  end
end

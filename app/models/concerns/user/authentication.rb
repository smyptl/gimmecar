module Concerns::User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password

    validates :first_name, :last_name,
      presence: true

    validates :email, uniqueness: true, presence: true
  end

  class_methods do
    def authenticate_by_token(token)
      payload = Lib::AuthToken.authenticate(token)

      find_by({
        :id                => payload.fetch('sub'),
        :email             => payload.fetch('email'),
        :persistence_token => payload.fetch('persistence_token')
      })
    end

    def authenticate_command_by_token(token)
      user = authenticate_by_token(token)
      user && user.command? ? user : nil
    end
  end

  def command?
    if !Rails.env.development?
      ['samay@gimmecar.com', 'jay@gimmecar.com'].include?(email)
    else
      true
    end
  end

  def issue_token
    reset_persistence_token

    Lib::AuthToken.issue({
      :sub               => id,
      :email             => email,
      :persistence_token => persistence_token,
    })
  end

  private

  def reset_persistence_token
    update(:persistence_token => SecureRandom.uuid)
  end
end

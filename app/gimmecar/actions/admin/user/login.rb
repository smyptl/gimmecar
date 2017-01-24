class Actions::Admin::User::Login < Lib::Forms::Base
  include Lib::Forms::Actions

  attr_reader :user, :auth_token

  attribute :email,    :string
  attribute :password, :string

  validates :email, :password,
    presence: true

  validate :authenticate

  private

  def authenticate
    if email && password
      @user = ::User.find_by(email: email).try(:authenticate, password)

      errors.add(:base, 'invalid email and/or password') if !user && errors.empty?
    end
  end

  def success_args
    {
      :token     => auth_token,
      :user      => { :name => user.name },
      :locations => Services::Admin::User::Locations.fetch(user)
    }
  end

  def save
    @auth_token = user.issue_token
  end
end

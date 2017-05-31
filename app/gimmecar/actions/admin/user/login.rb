class Actions::Admin::User::Login < Lib::Forms::Base
  
  attr_reader :user, :auth_token

  attributes do |a|
    a.string :email
    a.string :password
  end

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
      :token => auth_token,
      :user  => { :name => user.name },
      :links => {
        :next => next_link,
      },
    }
  end

  def next_link
    case user.number_of_locations
    when 1
      url_helper.location_dashboard_path(slug: user.locations.first.slug)
    else
      url_helper.locations_path
    end
  end

  def save
    @auth_token = user.issue_token
  end
end

class Command::LoginController < Command::BaseController

  before_action :authorize_api, only: :create
  skip_before_action :authenticate_user

  def index
    if current_user
      redirect_to command_rentals_path
    else
      render_layout
    end
  end

  def create
    success = lambda do |args|
      cookies.encrypted[:token] = {
        value:    args.fetch(:token),
        secure:   Rails.env.production?,
        expires:  1.month.from_now,
        httponly: true,
      }

      render json: nil, status: 200
    end

    Actions::Command::User::Login.new(params).execute(success, failure)
  end

  #def destroy
    #cookies.delete(:token)
  #end
end

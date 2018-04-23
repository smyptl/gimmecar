class Command::LoginController < ApplicationController
  include Command::Concerns::User
  include ::Concerns::Api

  layout 'command'

  before_action :authorize_api, only: :create

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
        secure:   Rails.env.production? || Rails.env.staging?,
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

  private

  def render_layout
    render 'command/index'
  end
end

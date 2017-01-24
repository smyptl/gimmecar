class Admin::TokenController < Admin::BaseController

  before_action :authenticate_user, only: [:destroy]

  layout 'admin'

  def index
  end

  def create
    success = lambda do |args|
      cookies.encrypted[:token] = {
        :value    => args.fetch(:token),
        :secure   => Rails.env.production?,
        :httponly => true,
      }

      render json: args, status: 200
    end

    failure = lambda do |args|
      render json: args, status: 404
    end

    Actions::Admin::User::Login.new(params.require(:login)).execute(success, failure)
  end

  #def destroy
    #cookies.delete(:token)
  #end
end

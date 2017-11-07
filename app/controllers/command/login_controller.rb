class Admin::LoginController < ApplicationController
  include Concerns::Api

  layout 'command'

  before_action :authorize_api, only: :create

  def index
    if current_user
      redirect_to admin_locations_path
    else
      render 'admin/login'
    end
  end

  def create
    success = lambda do |args|
      cookies.encrypted[:token] = {
        :value    => args.fetch(:token),
        :secure   => Rails.env.production? || Rails.env.staging?,
        :expires  => 1.year.from_now,
        :httponly => true,
      }

      render json: { links: args.fetch(:links) }, status: 200
    end

    failure = lambda do |args|
      render json: args, status: 404
    end

    Actions::Admin::User::Login.new(params.require(:login)).execute(success, failure)
  end

  #def destroy
    #cookies.delete(:token)
  #end

  private

  def render_layout
    render 'admin/login'
  end
end

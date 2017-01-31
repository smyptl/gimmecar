class Admin::LoginController < ApplicationController
  include Admin::Concerns::User
  include Admin::Concerns::Api

  layout 'admin'

  before_action :authorize_api, only: :create

  def index
    if current_user
      redirect_to location_dashboard_path(:slug => current_user.locations.first.slug)
    else
      render 'admin/login'
    end
  end

  def create
    success = lambda do |args|
      cookies.encrypted[:token] = {
        :value    => args.fetch(:token),
        :secure   => Rails.env.production?,
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

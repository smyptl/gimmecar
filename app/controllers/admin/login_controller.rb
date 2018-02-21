class Admin::LoginController < ApplicationController
  include ::Admin::Concerns::User
  include ::Concerns::Api

  layout 'admin'

  before_action :authorize_api, only: :create

  def index
    if current_user
      redirect_to admin_locations_path
    else
      render_layout
    end
  end

  def create
    success = lambda do |args|
      cookies.encrypted[:token] = {
        :value    => args.fetch(:token),
        :secure   => Rails.env.production? || Rails.env.staging?,
        :expires  => 1.month.from_now,
        :httponly => true,
      }

      render json: {}, status: 200
    end

    Actions::Admin::User::Login.new(params.require(:login)).execute(success, failure)
  end

  #def destroy
    #cookies.delete(:token)
  #end

  private

  def render_layout
    render 'admin/index'
  end
end

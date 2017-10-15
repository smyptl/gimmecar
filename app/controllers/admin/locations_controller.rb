class Admin::LocationsController < ApplicationController
  include Admin::Concerns::User
  include Admin::Concerns::Api

  layout 'admin'

  before_action :authenticate_user, :authorize_api

  def index
    render json: Services::Admin::User::Locations.fetch(current_user), status: 200
  end

  private

  def render_layout
    render 'admin/location'
  end
end

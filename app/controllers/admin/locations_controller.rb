class Admin::LocationsController < ApplicationController
  include Admin::Concerns::User

  before_action :authenticate_user

  def index
    render json: Services::Admin::User::Locations.fetch(current_user), status: 200
  end
end

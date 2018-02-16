class Admin::LocationsController < ApplicationController
  include ::Admin::Concerns::User
  include ::Concerns::Api

  layout 'admin'

  before_action :authenticate_user, :authorize_api

  def index
    Services::Admin::User::Locations.retrieve(success, failure, user: current_user)
  end

  private

  def render_layout
    render 'admin/index'
  end
end

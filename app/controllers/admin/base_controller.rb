class Admin::BaseController < ApplicationController
  include Concerns::Authentication
  include Concerns::Api

  before_action :authenticate_user, :authorize_api

  private

  def render_layout
    render template: '/admin', layout: false
  end

  def login_path
    admin_login_path
  end
end

class Command::BaseController < ApplicationController
  include Concerns::Authentication
  include Concerns::Api

  before_action :authenticate_user, :authorize_api

  private

  def render_layout
    render template: '/command', layout: false
  end

  def login_path
    command_login_path
  end
end

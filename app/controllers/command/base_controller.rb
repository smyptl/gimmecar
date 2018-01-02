class Command::BaseController < ApplicationController
  include ::Command::Concerns::User
  include ::Concerns::Api

  layout 'command'

  before_action :authenticate_user, :authorize_api

  private

  def render_layout
    render 'command/index'
  end

  def authenticate_location
    return if location

    if api?
      head 404
    else
      raise ApplicationController::Error404
    end
  end

  def success
    lambda do |args|
      render status: 200, :json => args
    end
  end

  def failure
    lambda do |args|
      render status: 400, :json => args
    end
  end
end

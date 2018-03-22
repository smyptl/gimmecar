class Command::BaseController < ApplicationController
  include ::Command::Concerns::User
  include ::Concerns::Api

  layout 'command'

  before_action :authenticate_user, :authorize_api

  private

  def render_layout
    render 'command/index'
  end
end

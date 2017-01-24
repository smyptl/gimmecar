class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  class Error401 < StandardError; end
  rescue_from Error401, :with => :render_401
  def render_401; render_error(401); end

  class Error403 < StandardError; end
  rescue_from Error403, :with => :render_403
  def render_403; render_error(403); end

  class Error404 < StandardError; end
  rescue_from Error404, :with => :render_404
  def render_404; render_error(404); end

  private

  def render_error(status)
    render :template => 'errors/error', :layout => false, :status => status
    return
  end
end

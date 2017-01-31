class ErrorsController < ApplicationController

  layout false

  def not_found
    render :template => "errors/error", :status => 404
  end

  def unacceptable
    render :template => "errors/error", :status => 422
  end

  def internal_error
    render :template => "errors/error", :status => 500
  end
end

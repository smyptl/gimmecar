module Concerns::AuthorizeApi

  def authorize_api
    raise ApplicationController::Error403 unless request.xhr?
  end
end

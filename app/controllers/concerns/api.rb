module Concerns::Api

  private

  def authorize_api
    render_layout unless api?
  end

  def api?
    request.xhr?
  end
end

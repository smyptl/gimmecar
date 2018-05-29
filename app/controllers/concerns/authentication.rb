module Concerns::Authentication

  private

  def authenticate_user
    return if current_user

    if api?
      head 400
    else
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= begin
                        ::User.authenticate_by_token(token, command: command?)
                      rescue JWT::DecodeError
                        nil
                      end
  end

  def current_user?
    current_user.present?
  end

  def token
    cookies.encrypted[:token]
  end

  def command?
    request.original_url.include?('command.')
  end
end

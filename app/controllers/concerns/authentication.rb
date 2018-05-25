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
                        ::User.authenticate_command_by_token(token)
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
end

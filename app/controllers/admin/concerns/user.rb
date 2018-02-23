module Admin::Concerns::User

  private

  def authenticate_user
    return if current_user

    if api?
      head 400
    else
      redirect_to admin_login_path
    end
  end

  def current_user
    @current_user ||= begin
                        ::User.authenticate_by_token(token)
                      rescue JWT::DecodeError
                        nil
                      end
  end

  def token
    cookies.encrypted[:token]
  end
end

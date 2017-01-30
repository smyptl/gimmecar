module Admin::Concerns::User

  private

  def authenticate_user
    return if current_user

    if api?
      head 404
    else
      raise Error404
    end
  end

  def current_user
    @current_user ||= begin
                        User.authenticate_by_token(token)
                      rescue
                        nil
                      end
  end

  def set_token
  end

  def token
    cookies.encrypted[:token]
  end
end

module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    current_user_from_session || current_user_from_cookies
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user.present?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Checks whether the remember me has been set
  def check_remember_me(remember_me, user)
    remember_me == '1' ? remember(user) : forget(user)
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  private

  # Returns the current user from the session.
  def current_user_from_session
    @current_user = User.find_by(id: session[:user_id])
  end

  # Returns the current user from cookies.
  def current_user_from_cookies
    user = User.find_by(id: cookies.signed[:user_id])

    if user && user.authenticated?(cookies[:remember_token], user.remember_digest)
      log_in user
      @current_user = user
    end
  end
end

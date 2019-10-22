class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email]&.downcase)
    if authenticate? user
      if active?(user)
      then
        login_in_and_redirect(user)
      else
        warn_and_redirect
      end
    else
      flash.now[:danger] = I18n.t 'sessions.invalid'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def authenticate?(user)
    user && user.authenticate(session_params[:password])
  end

  def active?(user)
    user.activated?
  end

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end

  def login_in_and_redirect(user)
    log_in user
    session_params[:remember_me] == '1' ? remember(user) : forget(user)
    redirect_back_or user
  end

  def warn_and_redirect
    flash[:warning] = I18n.t 'sessions.inactive'
    redirect_to root_url
  end
end

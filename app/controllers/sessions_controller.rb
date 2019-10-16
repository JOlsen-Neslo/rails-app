class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email]&.downcase)
    if user && user.authenticate(session_params[:password])
      check_if_activated user
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

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end

  def check_if_activated(user)
    if user.activated?
      log_in user
      session_params[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = I18n.t 'sessions.inactive'
      redirect_to root_url
    end
  end
end

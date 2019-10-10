class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email]&.downcase)
    if user && user.authenticate(session_params[:password])
      log_in user
      check_remember_me(session_params[:remember_me], user)
      redirect_to user
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
end

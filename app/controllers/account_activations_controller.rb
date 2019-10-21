class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params.require(:email))
    if is_user_activated_and_authenticated? user
      user.activate
      log_in user
      flash[:success] = I18n.t 'account.activation.success'
      redirect_to user
    else
      flash[:danger] = I18n.t 'account.activation.error'
      redirect_to root_url
    end
  end

  private

  def is_user_activated_and_authenticated?(user)
    user && !user.activated? && user.authenticated?(params.require(:id), user.activation_digest)
  end
end

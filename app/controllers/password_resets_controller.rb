class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :validate_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: password_reset_params[:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t 'resets.create.success'
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t 'resets.create.error'
      render 'new'
    end
  end

  def edit
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, I18n.t('resets.update.error'))
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = I18n.t 'resets.update.success'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_reset_params
    params.require(:password_reset).permit(:email)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def validate_user
    unless is_user_activated_and_authenticated? params.require(:id), user.activation_digest, :reset
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = I18n.t 'resets.update.expired'
      redirect_to new_password_reset_url
    end
  end
end

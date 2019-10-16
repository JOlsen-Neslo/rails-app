class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:edit, :update, :destroy]

  def index
    @users = User.paginate(page: page_params[:page])
  end

  def show
    @user = User.find(require_id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      log_in @user
      flash[:success] = I18n.t 'users.new.create.success'
      redirect_to @user
    else
      flash[:error] = I18n.t 'users.new.create.error'
      render 'new'
    end
  end

  def edit
    @user
  end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t 'users.edit.success'
      redirect_to @user
    else
      flash[:error] = I18n.t 'users.edit.error'
      render 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t 'users.destroy.success'
    else
      flash[:error] = I18n.t 'users.destroy.error'
    end
    redirect_to users_url
  end

  private

  def require_id
    params.require(:id)
  end

  def find_user
    @user = User.find(require_id)
    return true unless @user.nil?
    flash[:error] = I18n.t('users.find.error')
    false
  end

  def page_params
    params.permit(:page)
  end

  def user_params
    params
        .require(:user)
        .permit(
            :name,
            :nickname,
            :email,
            :password,
            :password_confirmation
        )
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = I18n.t('unauth')
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(require_id)
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end

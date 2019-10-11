class UsersController < ApplicationController
  def show
    @user = User.find(params.require(:id))
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

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def user_params
    params
        .require(:user)
        .permit(
            :name,
            :email,
            :password,
            :password_confirmation
        )
  end
end

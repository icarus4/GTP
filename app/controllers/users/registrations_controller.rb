class Users::RegistrationsController < ApplicationController
  layout 'empty'

  def new
  end

  def create
    @user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Account created'
    else
      render :new
    end
  end

  private

    def users_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end

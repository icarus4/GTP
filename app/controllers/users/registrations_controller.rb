class Users::RegistrationsController < ApplicationController
  layout 'empty'

  def new
  end

  def create
    @company = Company.new(name: params[:company_name].strip, status: 'active')
    render :new and return if !@company.save

    @user = User.new(email: params[:email].strip, password: params[:password], password_confirmation: params[:password_confirmation], company: @company)
    render :new and return if !@user.save

    session[:user_id] = @user.id
    redirect_to root_path, notice: 'Account created'
  end
end

class Users::RegistrationsController < ApplicationController
  layout 'empty'

  def new
  end

  def create
    @company = Company.new(name: params[:company_name].strip, status: 'active')
    @user = User.new(email: params[:email].strip, password: params[:password], password_confirmation: params[:password_confirmation], company: @company)

    begin
      ActiveRecord::Base.transaction do
        @company.save!
        @user.save!
      end
    rescue
      render :new and return
    end

    session[:user_id] = @user.id
    redirect_to root_path, notice: 'Account created'
  end
end

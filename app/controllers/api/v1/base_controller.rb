class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!
  
  def authenticate_user!
    render json: error_401_json, status: 401 and return unless user_signed_in?
  end

  def error_json(code, message = nil)
    error_hash = { error: { code: code } }
    error_hash[:error][:message]  = message if message.present?
    error_hash
  end


  def error_401_json
    error_json('LOGIN_IS_REQUIRED', 'Login is required')
  end
end

class Api::V1::EmployeesController < Api::V1::BaseController
  def index
    users = current_company.employees
    render json: { employees: users.as_json(only: [:id, :name, :email, :phone_number]) }
  end
end

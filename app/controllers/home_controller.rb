class HomeController < ApplicationController
  def index
    case current_user.role
    when "admin"
      @objectives = Objective.includes(:employee, :rater).all
      @objective = Objective.new
      render "home/admin_dashboard"
    when "leader"
      @objectives = Objective.includes(:employee).where(employee_id: current_user.employees.pluck(:id))
      @objective = Objective.new
      render "home/leader_dashboard"
    when "employee"
      @objectives = Objective.where(employee: current_user)
      @objective = Objective.new
      render "home/employee_dashboard"
    else
      redirect_to root_path, alert: "Rol no reconocido"
    end
  end
end
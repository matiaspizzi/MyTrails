class HomeController < ApplicationController
  def index
    @objective = Objective.new
    if current_user.role == "admin"
      @objectives = Objective.includes(:employee, :rater).all
      render "home/admin_dashboard"
    else
      @objectives = Objective.where(employee: current_user).includes(:employee, :rater).order(status: :asc, created_at: :asc)
      render "home/employee_dashboard"
    end
  end
end

class HomeController < ApplicationController
  def index
    @objective = Objective.new
    if current_user.admin?
      @pagy, @objectives = pagy(Objective.includes(:employee, :rater).order(created_at: :desc))
      render "admin/dashboard"
    else
      @pagy, @objectives = pagy(Objective.where(employee: current_user).includes(:employee, :rater).order(status: :asc, created_at: :asc))
      render "home/employee_dashboard"
    end
  end
end

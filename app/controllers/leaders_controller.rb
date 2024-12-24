class LeadersController < ApplicationController
  def dashboard
    if current_user.role != "leader"
      redirect_to root_path, alert: "You don't have permission to access this page."
    end
    if params[:query].present?
        @objectives = Objective.joins("INNER JOIN users ON users.id = objectives.employee_id")
                               .where(employee_id: current_user.employees.pluck(:id))
                               .where(
                                 "objectives.title ILIKE :query
                                  OR objectives.description ILIKE :query
                                  OR users.name ILIKE :query
                                  OR users.surname ILIKE :query
                                  OR users.email_address ILIKE :query
                                  OR CAST(objectives.estimated_completion_at AS TEXT) ILIKE :query",
                                 query: "%#{params[:query]}%"
                               ).order(Arel.sql("CASE WHEN status = 2 THEN 0 ELSE 1 END"), :status, :created_at)
    else
      # objectives with status In Review, first
      @objectives = Objective.includes(:employee)
      .where(employee_id: current_user.employees.pluck(:id))
      .order(Arel.sql("CASE WHEN status = 2 THEN 0 ELSE 1 END"), :status, :created_at)
    end
    render "leader/dashboard"
  end
end
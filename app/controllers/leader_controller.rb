class LeaderController < ApplicationController
  def dashboard
    if current_user.role != "leader"
      redirect_to root_path, alert: "No tienes permisos para acceder a esta página"
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
                               )
    else
      @objectives = Objective.includes(:employee).where(employee_id: current_user.employees.pluck(:id))
    end
    render "home/leader_dashboard"
  end
end

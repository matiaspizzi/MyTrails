# filepath: /c:/Users/matia/Desktop/trails/app/controllers/objectives_controller.rb
class ObjectivesController < ApplicationController
  before_action :set_objective, only: [ :destroy, :update, :rate, :unrate, :details ]

  def index
    redirect_to root_path
  end

  def details
    if @objective == nil
      redirect_to leader_dashboard_path, alert: "We could not find the objective you are looking for."
    end

    if (current_user.role == "employee" || !current_user.employees.include?(@objective.employee)) && current_user.role != "admin"
        redirect_to root_path, alert: "You don't have permission to access this page."
        return
    end
    render "objectives/details"
  end

  def create
    @objective = Objective.new(objective_params)
    @objective.employee = current_user

    if @objective.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Objective was successfully created." }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Failed to create objective." }
        format.turbo_stream { render :new }
      end
    end
  end

  def update
    if @objective.update(objective_params)
      redirect_to root_path, notice: "El estado del objetivo se ha actualizado correctamente."
    else
      redirect_to root_path, alert: "No se pudo actualizar el estado del objetivo."
    end
  end

  def destroy
    if @objective.status == "Done"
      flash[:alert] = "You can't delete a completed objective."
      redirect_to objectives_path
      return
    end
    @objective.destroy
    flash[:notice] = "Objective deleted successfully."
    redirect_to objectives_path
  end

  def rate
    if @objective.update(rating: params[:rating], status: 3, rated_by: current_user.id)
      flash[:success] = "Rating updated successfully!"
    else
      flash[:error] = "Failed to update rating."
    end

    redirect_back(fallback_location: objectives_path)
  end

  def unrate
    @objective.rating = nil
    @objective.rated_by = nil
    @objective.save
    redirect_to root_path
  end

  private

  def is_rated?
    @objective.rating.present?
  end

  def set_objective
    @objective = Objective.includes(:employee, :rater).find(params[:id])
  end

  def objective_params
    params.require(:objective).permit(:title, :description, :estimated_completion_at, :status, :id)
  end
end

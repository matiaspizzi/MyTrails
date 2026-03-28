class ObjectivesController < ApplicationController
  before_action :set_objective, only: [ :destroy, :update, :rate, :unrate, :details ]

  def index
    redirect_to root_path
  end

  def details
    authorize @objective
    render "objectives/details"
  end

  def create
    @objective = Objective.new(objective_params)
    @objective.employee = current_user
    authorize @objective

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
    authorize @objective
    if @objective.update(objective_params)
      redirect_to root_path, notice: "Objective status updated successfully."
    else
      redirect_to root_path, alert: "Failed to update objective status."
    end
  end

  def destroy
    authorize @objective
    if @objective.status == "Done"
      redirect_to root_path, alert: "You can't delete a completed objective."
      return
    end
    @objective.destroy
    redirect_to root_path, notice: "Objective deleted successfully."
  end

  def rate
    authorize @objective
    if @objective.update(rating: params[:rating], status: :Done, rated_by: current_user.id)
      flash[:notice] = "Rating updated successfully."
    else
      flash[:alert] = "Failed to update rating."
    end
    redirect_back(fallback_location: root_path)
  end

  def unrate
    authorize @objective
    @objective.rating = nil
    @objective.rated_by = nil
    if @objective.save
      redirect_to root_path, notice: "Rating removed successfully."
    else
      redirect_to root_path, alert: "Failed to remove rating."
    end
  end

  private

  def set_objective
    @objective = Objective.includes(:employee, :rater).find(params[:id])
  end

  def objective_params
    params.require(:objective).permit(:title, :description, :estimated_completion_at, :status, :id)
  end
end

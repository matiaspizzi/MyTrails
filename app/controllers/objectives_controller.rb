# filepath: /c:/Users/matia/Desktop/trails/app/controllers/objectives_controller.rb
class ObjectivesController < ApplicationController
  def create
    @objective = Objective.new(objective_params)
    @objective.employee = current_user if current_user.role == "employee"
    
    if @objective.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Objective was successfully created.' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: 'Failed to create objective.' }
        format.turbo_stream { render :new }
      end
    end
  end

  def update
    @objective = Objective.find(params[:id])
    @objective.update(objective_params)
    redirect_to root_path
  end

  def destroy
    @objective = Objective.find(params[:id])
    @objective.destroy
    redirect_to root_path
  end

  def rate
    @objective = Objective.find(params[:id])
    @objective.rating = params[:rating]
    @objective.rated_by = current_user
    @objective.save
    redirect_to root_path
  end

  def unrate
    @objective = Objective.find(params[:id])
    @objective.rating = nil
    @objective.rated_by = nil
    @objective.save
    redirect_to root_path
  end

  private

  def objective_params
    params.require(:objective).permit(:title, :description, :estimated_completion_at)
  end
end
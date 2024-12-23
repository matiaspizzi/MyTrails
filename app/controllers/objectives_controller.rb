# filepath: /c:/Users/matia/Desktop/trails/app/controllers/objectives_controller.rb
class ObjectivesController < ApplicationController
  before_action :set_objective, only: [:destroy, :update, :rate, :unrate, :show]
  
  def index
    redirect_to root_path
  end

  def show
  end

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
    if @objective.update(objective_params)
      redirect_to root_path, notice: 'El estado del objetivo se ha actualizado correctamente.'
    else
      redirect_to root_path, alert: 'No se pudo actualizar el estado del objetivo.'
    end
  end

  def destroy
    @objective.destroy
    flash[:notice] = "Objective deleted successfully."
    redirect_to objectives_path
  end

  def rate
    @objective.rating = params[:rating]
    @objective.rated_by = current_user
    @objective.save
    redirect_to root_path
  end

  def unrate
    @objective.rating = nil
    @objective.rated_by = nil
    @objective.save
    redirect_to root_path
  end

  private

  def set_objective
    @objective = Objective.find(params[:id])
  end

  def objective_params
    params.require(:objective).permit(:title, :description, :estimated_completion_at, :status)
  end
end
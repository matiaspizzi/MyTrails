class LeadershipsController < ApplicationController
  def index
    authorize Leadership, :index?
    @leaderships = Leadership.includes(:leader, :employee).all
    @leaderships_grouped_by_leader = @leaderships.group_by(&:leader)
    render "admin/leaderships"
  end

  def create
    authorize Leadership
    if leadership_params[:leader_email] == leadership_params[:employee_email]
      redirect_to leaderships_path, alert: "Leader and employee cannot be the same."
      return
    end

    @leader = User.find_by(email_address: leadership_params[:leader_email])
    @employee = User.find_by(email_address: leadership_params[:employee_email])

    if @leader.nil?
      redirect_to leaderships_path, alert: "Leader not found."
      return
    elsif @employee.nil?
      redirect_to leaderships_path, alert: "Employee not found."
      return
    elsif !@leader.leader?
      redirect_to leaderships_path, alert: "#{@leader.name.titleize} is not a leader."
      return
    end

    @leadership = Leadership.new(leader: @leader, employee: @employee)
    if @leadership.save
      redirect_to leaderships_path, notice: "Leadership was successfully created."
    else
      redirect_to leaderships_path, alert: "Failed to create leadership."
    end
  end

  def destroy
    @leadership = Leadership.find(params[:id])
    authorize @leadership
    @leadership.destroy
    redirect_to leaderships_path, notice: "Leadership was successfully removed."
  end

  private

  def leadership_params
    params.require(:leadership).permit(:leader_email, :employee_email, :id)
  end
end

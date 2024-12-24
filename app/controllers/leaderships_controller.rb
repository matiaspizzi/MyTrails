class LeadershipsController < ApplicationController

  def show
    @leaderships = Leadership.includes(:leader, :employee).all
    @leaderships_grouped_by_leader = @leaderships.group_by(&:leader)
    if current_user.role != "admin"
        redirect_to root_path, alert: "You don't have permission to access this page."
        return
    end
    render 'admin/leaderships'
  end

  def create
    @leader = User.find_by(email_address: leadership_params[:leader_email])
    @employee = User.find_by(email_address: leadership_params[:employee_email])

    if @leader == nil || @employee == nil
      redirect_to leadership_path, alert: ( @leader == nil ? "Leader not found." : "Employee not found." )
      return
    elsif @leader.role != "leader"
      redirect_to leadership_path, alert: @leader.name.titleize + " is not a leader."
      return
    end
    @leadership = Leadership.new(leader: @leader, employee: @employee)
    if @leadership.save
      redirect_to leadership_path, notice: 'Leadership was successfully created.'
    else
      redirect_to leadership_path, alert: 'Failed to create leadership.'
    end

  end

  def destroy
    if current_user.role != "admin"
      redirect_to root_path, alert: "You don't have permission to access this page."
      return
    end
    @leadership = Leadership.find(params[:id])
    @leadership.destroy
    redirect_to leadership_path, notice: 'Leadership was successfully removed.'
  end

  private

  def leadership_params
    params.require(:leadership).permit(:leader_email, :employee_email, :id)
  end
end
class LeadershipsController < ApplicationController
  def index
    authorize Leadership, :index?
    @leaderships = Leadership.includes(:leader, :employee).all
    @leaderships_grouped_by_leader = @leaderships.group_by(&:leader)
    render "admin/leaderships"
  end

  def create
    authorize Leadership, :create?
    if leadership_params[:leader_email] == leadership_params[:employee_email]
      redirect_to leaderships_path, alert: t("leaderships.same_user")
      return
    end

    @leader = User.find_by(email_address: leadership_params[:leader_email])
    @employee = User.find_by(email_address: leadership_params[:employee_email])

    if @leader.nil?
      redirect_to leaderships_path, alert: t("leaderships.leader_not_found")
      return
    elsif @employee.nil?
      redirect_to leaderships_path, alert: t("leaderships.employee_not_found")
      return
    elsif !@leader.leader?
      redirect_to leaderships_path, alert: t("leaderships.not_a_leader", name: @leader.name.titleize)
      return
    end

    @leadership = Leadership.new(leader: @leader, employee: @employee)
    if @leadership.save
      redirect_to leaderships_path, notice: t("leaderships.created")
    else
      redirect_to leaderships_path, alert: t("leaderships.create_failed")
    end
  end

  def destroy
    @leadership = Leadership.find(params[:id])
    authorize @leadership
    @leadership.destroy
    redirect_to leaderships_path, notice: t("leaderships.destroyed")
  end

  private

  def leadership_params
    params.require(:leadership).permit(:leader_email, :employee_email, :id)
  end
end

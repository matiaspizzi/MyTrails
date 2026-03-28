class LeadersController < ApplicationController
  def dashboard
    authorize current_user, :view_leader_dashboard?, policy_class: UserPolicy
    @pagy, @objectives = pagy(
      Objective.includes(:employee)
               .where(employee: current_user.employees)
               .then { params[:query].present? ? _1.search(params[:query]) : _1 }
               .in_review_first
    )
    render "leader/dashboard"
  end
end

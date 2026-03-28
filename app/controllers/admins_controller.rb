class AdminsController < ApplicationController
  def dashboard
    authorize current_user, :view_admin_dashboard?, policy_class: UserPolicy
    @pagy, @objectives = pagy(
      Objective.includes(:employee)
               .then { params[:query].present? ? _1.search(params[:query]) : _1 }
               .in_review_first
    )
    render "admin/dashboard"
  end
end

class UserPolicy < ApplicationPolicy
  def show_all? = user.admin?
  def set_role? = user.admin?
  def view_admin_dashboard? = user.admin?
  def view_leader_dashboard? = user.leader?

  def update_profile_image? = user == record
  def delete_profile_image? = user == record
end

class UserPolicy < ApplicationPolicy
  def show_all? = user.role == "admin"
  def set_role? = user.role == "admin"
  def view_admin_dashboard? = user.role == "admin"
  def view_leader_dashboard? = user.role == "leader"

  def update_profile_image? = user == record
  def delete_profile_image? = user == record
end

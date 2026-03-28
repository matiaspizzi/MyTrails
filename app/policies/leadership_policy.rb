class LeadershipPolicy < ApplicationPolicy
  def show? = user.role == "admin"
  def create? = user.role == "admin"
  def destroy? = user.role == "admin"
end

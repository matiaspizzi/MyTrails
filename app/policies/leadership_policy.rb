class LeadershipPolicy < ApplicationPolicy
  def show? = user.admin?
  def create? = user.admin?
  def destroy? = user.admin?
end

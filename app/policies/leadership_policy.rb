class LeadershipPolicy < ApplicationPolicy
  def index? = user.admin?
  def create? = user.admin?
  def destroy? = user.admin?
end

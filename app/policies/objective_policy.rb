class ObjectivePolicy < ApplicationPolicy
  def create? = true

  def update? = record.employee == user

  def destroy? = record.employee == user

  def details?
    user.admin? || (user.leader? && user.employees.include?(record.employee))
  end

  def rate?
    user.leader? || user.admin?
  end

  def unrate? = rate?
end

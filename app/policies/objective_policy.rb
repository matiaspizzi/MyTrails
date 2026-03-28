class ObjectivePolicy < ApplicationPolicy
  def create? = true

  def update? = record.employee == user

  def destroy? = record.employee == user

  def details?
    user.role == "admin" ||
      (user.role == "leader" && user.employees.include?(record.employee))
  end

  def rate?
    user.role == "leader" || user.role == "admin"
  end

  def unrate? = rate?
end

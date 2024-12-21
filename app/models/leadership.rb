class Leadership < ApplicationRecord
  belongs_to :leader, class_name: "User", foreign_key: "leader_id"
  belongs_to :employee, class_name: "User", foreign_key: "employee_id"
end
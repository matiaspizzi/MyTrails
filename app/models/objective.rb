class Objective < ApplicationRecord
  belongs_to :employee, class_name: "User", foreign_key: "employee_id"
  belongs_to :rater, class_name: "User", foreign_key: "rated_by", optional: true
end
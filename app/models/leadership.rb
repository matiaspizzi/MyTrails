class Leadership < ApplicationRecord
  belongs_to :leader, class_name: "User"
  belongs_to :employee, class_name: "User"
end

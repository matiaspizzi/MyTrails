class Objective < ApplicationRecord
  belongs_to :employee, class_name: "User"
  belongs_to :rater, class_name: "User", foreign_key: "rated_by", optional: true

  validates :title, :description, presence: true
  validates :estimated_completion_at, presence: true, future_date: true

  enum :status, { New: 0, In_Progress: 1, In_Review: 2, Done: 3 }, default: :New

  validates :status, presence: true
end

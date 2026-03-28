class Objective < ApplicationRecord
  belongs_to :employee, class_name: "User"
  belongs_to :rater, class_name: "User", foreign_key: "rated_by", optional: true

  validates :title, :description, presence: true
  validates :estimated_completion_at, presence: true, future_date: true

  enum :status, { New: 0, In_Progress: 1, In_Review: 2, Done: 3 }, default: :New

  validates :status, presence: true

  scope :in_review_first, -> {
    order(Arel.sql("CASE WHEN status = 2 THEN 0 ELSE 1 END"), :status, :created_at)
  }

  scope :search, ->(query) {
    joins("INNER JOIN users ON users.id = objectives.employee_id")
      .where(
        "objectives.title ILIKE :q
         OR objectives.description ILIKE :q
         OR users.name ILIKE :q
         OR users.surname ILIKE :q
         OR users.email_address ILIKE :q
         OR CAST(objectives.estimated_completion_at AS TEXT) ILIKE :q",
        q: "%#{sanitize_sql_like(query)}%"
      )
  }
end

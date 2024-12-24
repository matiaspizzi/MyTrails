class User < ApplicationRecord
  has_secure_password
  has_secure_token :confirmation_token
  has_many :sessions, dependent: :destroy

  # Associations with inverse_of and dependent options
  has_many :objectives, foreign_key: :employee_id, class_name: "Objective", inverse_of: :employee

  has_many :leaderships, foreign_key: :leader_id, class_name: "Leadership", inverse_of: :leader, dependent: :destroy
  has_many :employees, through: :leaderships, source: :employee, inverse_of: :leaders

  has_many :inverse_leaderships, foreign_key: :employee_id, class_name: "Leadership", inverse_of: :employee, dependent: :destroy
  has_many :leaders, through: :inverse_leaderships, source: :leader, inverse_of: :employees

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :validate_profile_image_size

  def confirm!
    update!(confirmed_at: Time.current, confirmation_token: nil)
  end

  def confirmed?
    confirmed_at.present?
  end

  def send_confirmation_instructions
    regenerate_confirmation_token
    UserMailer.confirmation_instructions(self).deliver_now
  end

  def validate_profile_image_size
    return if profile_image.blank?

    # Decode Base64 to calculate the size
    size_in_bytes = Base64.decode64(profile_image).bytesize
    max_size_in_bytes = 1.megabyte

    if size_in_bytes > max_size_in_bytes
      errors.add(:profile_image, "The image is too large. The maximum size is 1MB.")
    end
  end
end

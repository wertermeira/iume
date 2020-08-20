class OwnerPasswordValidation
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :password_current, :password, :current_user, :email

  validates :password_current, presence: true, if: -> { password.present? || check_email }
  validate :check_password, if: -> { password.present? || check_email }
  validates :email, email: true, if: -> { email.present? }

  private

  def check_password
    return if password_current.blank?

    return if current_user.authenticate(password_current)

    errors.add(:password_current, I18n.t('errors.messages.login.invalid_password'))
  end

  def check_email
    email.downcase != current_user.email if email.present?
  end
end

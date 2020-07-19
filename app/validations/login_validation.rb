class LoginValidation
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email, :password, :model

  validates :email, :password, presence: true
  validates :email, email: true, if: -> { email.present? }
  validate :user_exists, if: -> { email.present? }

  private

  def user_exists
    return if errors.present?

    return if model.find_by(email: email)

    errors.add(:email, I18n.t('errors.messages.login.email_not_found'))
  end
end

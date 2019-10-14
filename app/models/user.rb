class User < ApplicationRecord
  include AuthenticationConcern

  attr_accessor :remember_token

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_secure_password

  # Returns a random token.
  def new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = new_token
    update_attribute(:remember_digest, digest(self.remember_token))
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end

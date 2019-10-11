module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    # Returns the hash digest of the given string.
    def digest(string)
      cost = determine_cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Determines the correct 'cost' for password hashing
    def determine_cost
      ActiveModel::SecurePassword.min_cost ?
          BCrypt::Engine::MIN_COST :
          BCrypt::Engine.cost
    end

    # Returns true if the given token matches the digest.
    def authenticated?(remember_token, remember_digest = nil)
      return false if remember_digest.nil?
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  end
end

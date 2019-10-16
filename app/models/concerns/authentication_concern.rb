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
    def authenticated?(token, digest = nil)
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
  end
end

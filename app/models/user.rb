# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  remember_digest :string
#

class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    # constant
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+[.][a-z]+\z/i

  attr_accessor :remember_token

  before_save { self.email = email.downcase }   # self keyword is optional
                                                # on right-hand side

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # class-methods
  class << self
    # Returns the hash digest of the given string
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # generate random base64 token as remember-token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Creates a ramdom token and stores it in the database for use in
  # persistent sessions
  def remember
    # generate random remember-token
    self.remember_token = User.new_token

    # save remember-token into database with the user
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user (if he is remembered) by setting db-field to nil
  def forget
    update_attribute :remember_digest, nil
  end
end

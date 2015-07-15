# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default("f")
#  activation_digest :string
#  activated         :boolean          default("f")
#  activated_at      :datetime
#

class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    # constant
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+[.][a-z]+\z/i

  # Getter & Setters for 'virtual User variables'
  # (those who are not saved in the database, but are assigned to User class)
  attr_accessor :remember_token, :activation_token, :reset_token

  # Callbacks which are called before something happens with the Object.
  # The callbacks get either a block or a method reference as argument
  before_save :downcase_email
  before_create :create_activation_digest

  # Validations of the user object which should be saved in the database.
  # A validation error results in a rollback
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user (if he is remembered) by setting db-field to nil
  def forget
    update_attribute :remember_digest, nil
  end

  # Activates an account
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Send activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)

  end

  # Sends a password reset mail
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Is Passwort reset time expired?
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
    # Converts emil to all lower-case
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token & digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end

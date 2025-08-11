class CustomerUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :customer

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :customer_id, presence: true
  validates :blocked, inclusion: { in: [true, false] }

  scope :active, -> { where(blocked: false) }
  scope :blocked, -> { where(blocked: true) }

  def self.ransackable_attributes(auth_object = nil)
    ["blocked", "created_at", "customer_id", "email", "id", "name", "phone_number", "surname", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer"]
  end

  def full_name
    "#{name} #{surname}".strip
  end

  def active?
    !blocked
  end

  def send_password_generation_instructions
    raw, hashed = Devise.token_generator.generate(CustomerUser, :reset_password_token)
    self.reset_password_token = hashed
    self.reset_password_sent_at = Time.now.utc
    self.save

    # TODO: Implementar CustomerUserMailer personalizado
    # CustomerUserMailer.password_generation_instructions(self, raw).deliver_now
  end

  def self.create_without_password(attributes)
    # Temporarily set a random password for validation
    temp_password = Devise.friendly_token(20)
    user = self.new(attributes.merge(
      password: temp_password,
      password_confirmation: temp_password
    ))
    
    if user.save
      # Clear the password after saving - user will set it via "Generate Password"
      user.update_columns(encrypted_password: '')
      user
    else
      user
    end
  end
end

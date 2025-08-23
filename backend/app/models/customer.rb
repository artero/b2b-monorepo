class Customer < ApplicationRecord
  has_many :customer_users, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email?

  def self.ransackable_attributes(auth_object = nil)
    [ "code", "created_at", "email", "id", "name", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "customer_users" ]
  end
end

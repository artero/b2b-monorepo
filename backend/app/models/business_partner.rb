class BusinessPartner < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :ln_id, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email?

  scope :with_users, -> { includes(:users) }


  def self.ransackable_attributes(auth_object = nil)
    [ "ln_id", "created_at", "email", "id", "name", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "users" ]
  end
end

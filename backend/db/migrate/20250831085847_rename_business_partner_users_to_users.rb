class RenameBusinessPartnerUsersToUsers < ActiveRecord::Migration[8.0]
  def change
    rename_table :business_partner_users, :users
  end
end

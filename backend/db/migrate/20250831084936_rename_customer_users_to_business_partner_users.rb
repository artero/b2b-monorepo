class RenameCustomerUsersToBusinessPartnerUsers < ActiveRecord::Migration[8.0]
  def change
    rename_table :customer_users, :business_partner_users
    rename_column :business_partner_users, :customer_id, :business_partner_id
  end
end

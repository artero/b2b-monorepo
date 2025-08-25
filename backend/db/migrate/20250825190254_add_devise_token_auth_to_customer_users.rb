class AddDeviseTokenAuthToCustomerUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :customer_users, :provider, :string, null: false, default: 'email'
    add_column :customer_users, :uid, :string, null: false, default: ''
    add_column :customer_users, :tokens, :text

    # Update existing users
    CustomerUser.reset_column_information
    CustomerUser.find_each do |user|
      user.uid = user.email
      user.provider = 'email'
      user.save!
    end

    add_index :customer_users, [ :uid, :provider ], unique: true
  end
end

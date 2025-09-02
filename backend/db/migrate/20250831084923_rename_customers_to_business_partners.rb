class RenameCustomersToBusinessPartners < ActiveRecord::Migration[8.0]
  def change
    rename_table :customers, :business_partners
  end
end

class DropUnusedAdminsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :admins if table_exists?(:admins)
  end
end

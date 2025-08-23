class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :email

      t.timestamps
    end

    add_index :customers, :name, unique: true
    add_index :customers, :code, unique: true
    add_index :customers, :email, unique: true, where: "email IS NOT NULL"
  end
end

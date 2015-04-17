class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :account_number, null: false
      t.string :email, null: false
      t.string :istock_username
      t.string :istock_account_number
      t.boolean :enabled, default: false
      t.timestamps
    end

    add_index :users, :username
    add_index :users, :account_number
  end
end

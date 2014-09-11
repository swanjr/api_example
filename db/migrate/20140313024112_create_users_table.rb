class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :account_id
      t.string :istock_account_id
      t.string :email
      t.timestamps
    end

    add_index :users, :username
    add_index :users, :account_id
  end
end

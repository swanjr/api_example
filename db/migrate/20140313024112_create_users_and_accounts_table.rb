class CreateUsersAndAccountsTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :account_id
      t.string :email
      t.timestamps
    end

    create_table :associated_accounts do |t|
      t.references :user
      t.string :type
      t.string :username
      t.string :account_id
      t.timestamps
    end

    add_index :users, :username
    add_index :associated_accounts, :user_id
  end
end

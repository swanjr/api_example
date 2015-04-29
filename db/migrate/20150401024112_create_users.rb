class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false,
        index: true
      t.string :account_number, null: false,
        index: true
      t.string :email, null: false
      t.string :istock_username
      t.string :istock_account_number
      t.boolean :enabled, default: false,
        index: true
      t.timestamps null: false
    end
  end
end

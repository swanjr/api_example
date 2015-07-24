class CreateGroupsAndPermissions < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false, index: true
      t.timestamps null: false
    end

    create_table :permissions do |t|
      t.string :name, null: false, index: true
      t.timestamps null: false
    end

    create_table :group_permissions, id: false do |t|
      t.belongs_to :group, null: false
      t.belongs_to :permission, null: false
    end

    add_index :group_permissions, [:group_id, :permission_id], unique: true

    create_table :user_permissions, id: false do |t|
      t.belongs_to :user, null: false
      t.belongs_to :permission, null: false
    end

    add_index :user_permissions, [:user_id, :permission_id], unique: true

    create_table :group_users, id: false do |t|
      t.belongs_to :group, null: false
      t.belongs_to :user, null: false
    end

    add_index :group_users, [:group_id, :user_id], unique: true

    # Foreign keys must be added after the add_index so they are remove before it in a rollback.
    # If they are not remove first the removal of the above index will fail.
    add_foreign_key :group_permissions, :groups, on_delete: :cascade
    add_foreign_key :group_permissions, :permissions, on_delete: :cascade

    add_foreign_key :user_permissions, :users, on_delete: :cascade
    add_foreign_key :user_permissions, :permissions, on_delete: :cascade

    add_foreign_key :group_users, :groups, on_delete: :cascade
    add_foreign_key :group_users, :users, on_delete: :cascade
  end
end

class CreateRolesAndUserRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false, index: true
      t.timestamps null: false
    end

    create_table :users_roles do |t|
      t.belongs_to :user, null: false,
        index: true,
        foreign_key: { on_delete: :cascade }
      t.belongs_to :role, null: false,
        index: true,
        foreign_key: { on_delete: :cascade }
    end
  end
end

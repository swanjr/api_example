class AddWhodunnitIndexAndRequestIdColumn < ActiveRecord::Migration
  def change
    add_column :versions, :request_id, :string

    add_index :versions, [:whodunnit, :request_id]
  end
end

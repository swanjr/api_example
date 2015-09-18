class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :owner_id, null: false
      t.belongs_to :file_info,
        index: true
      t.belongs_to :submission_batch,
        index: true
      t.belongs_to :media, null: false,
        index: true,
        polymorphic: true
      t.string :type, null: false,
        index: true
      t.string :status, null: false,
        index: true
      t.string :master_id,
        index: true
      t.string :istock_master_id,
        index: true
      t.datetime :submitted_at,
        index: true
      t.datetime :published_at
      t.timestamps null: false
    end

    add_foreign_key :contributions, :users,
      column: :owner_id, name: 'contributions_owner_id_fk'
    add_foreign_key :contributions, :file_info,
      on_delete: :nullify
    add_foreign_key :contributions, :submission_batches,
      on_delete: :nullify
  end
end

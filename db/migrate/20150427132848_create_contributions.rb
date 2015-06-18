class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :owner_id, null: false,
        index: true,
        foreign_key: { column: :owner_id, name: 'contributions_owner_id_fk' }
      t.belongs_to :file_upload,
        index: true,
        foreign_key: { on_delete: :nullify }
      t.belongs_to :submission_batch,
        index: true,
        foreign_key: {on_delete: :nullify}
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
  end
end

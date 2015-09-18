class CreateSubmissionBatches < ActiveRecord::Migration
  def change
    create_table :submission_batches do |t|
      t.integer :owner_id, null: false
      t.string :allowed_contribution_type, null: false,
        index: true
      t.string :name, null: false
      t.string :status, null: false
      t.datetime :last_contribution_submitted_at
      t.boolean :apply_extracted_metadata, default: true
      t.string :event_id
      t.string :brief_id
      t.string :assignment_id
      t.timestamps null: false
    end

    add_foreign_key :submission_batches, :users,
      column: :owner_id, name: 'submission_batches_owner_id_fk'
  end
end


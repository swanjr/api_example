class CreateSubmissionBatches < ActiveRecord::Migration
  def change
    create_table :submission_batches do |t|
      t.integer :owner_id, null: false,
        foreign_key: { column: :owner_id, name: 'submission_batches_owner_id_fk' }
      t.string :allowed_contribution_type, null: false,
        index: true
      t.string :name, null: false
      t.string :status, null: false
      t.datetime :last_contribution_submitted_at
      t.timestamps null: false
    end
  end
end


class CreateSubmissionBatchesTable < ActiveRecord::Migration
  def change
    create_table :submission_batches do |t|
      t.integer :owner_id, null: false
      t.string :name, null: false
      t.string :allowed_contribution_type, null: false
      t.string :status, null: false
      t.datetime :last_contribution_submitted_at
      t.timestamps null: false
    end

    add_index :submission_batches, :owner_id
    add_index :submission_batches, :allowed_contribution_type

    add_foreign_key :submission_batches, :users, column: :owner_id
  end
end


class CreateSubmissionBatches < ActiveRecord::Migration
  def change
    create_table :submission_batches do |t|
      t.integer :owner_id
      t.string :name
      t.string :media_type
      t.string :asset_family
      t.boolean :istock
      t.string :status
      t.datetime :last_contribution_submitted_at
      t.timestamps
    end
  end
end

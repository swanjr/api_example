class CreateFileUploads < ActiveRecord::Migration
  def change
    create_table :file_uploads do |t|
      t.string :name, null: false
      t.string :path
      t.string :upload_bucket
      t.string :final_bucket
      t.text   :external_file_location
      t.string :upload_id,
        index: true
      t.string :mime_type
      t.timestamps null: false
    end
  end
end

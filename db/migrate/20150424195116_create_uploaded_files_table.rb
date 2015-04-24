class CreateUploadedFilesTable < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :name, null: false
      t.string :path
      t.string :upload_bucket
      t.string :final_bucket
      t.text   :external_file_location
      t.string :upload_id
      t.string :mime_type
      t.timestamps
    end
  end
end

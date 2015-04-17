class RefactorContributionTables < ActiveRecord::Migration
  def change
    #Create new tables
    create_table :files do |t|
      t.string :file_name, null: false
      t.string :file_path
      t.string :upload_bucket, null: false
      t.string :final_bucket
      t.string :external_file_location
      t.string :upload_id
      t.string :mime_type
      t.timestamps null: false
    end

    create_table :videos do |t|
      t.string  :clip_length
      t.string  :frame_composition
      t.string  :frame_rate
      t.string  :frame_size
      t.string  :compression
      t.string  :media_format
      t.string  :original_frame_composition
      t.string  :original_frame_rate
      t.string  :original_frame_size
      t.string  :original_media_format
      t.string  :original_production_title
      t.string  :shot_speed
      t.string  :preview_job_id
      t.string  :preview_path
      t.string  :thumbnail_path
      t.string  :clip_type
      t.float   :poster_time
      t.string  :poster_timecode
      t.string  :extracted_poster_timecode
      t.boolean :audio
    end

    #Add columns to existing tables
    add_reference :contributions, :file
    add_reference :csv_templates, :file
    add_reference :releases, :file
    add_reference :keywords, :contribution

    add_column :contributions, :title, :string
    add_column :contributions, :description, :string
    add_column :contributions, :city, :string
    add_column :contributions, :province_state, :string
    add_column :contributions, :country, :string
    add_column :contributions, :date_created, :datetime
    add_column :contributions, :personalities, :text
    add_column :contributions, :copyright, :string
    add_column :contributions, :event_id, :string
    add_column :contributions, :iptc_category, :string
    add_column :contributions, :iptc_subject, :string
    add_column :contributions, :source_code, :string
    add_column :contributions, :parent_source, :string
    add_column :contributions, :language, :string
    add_column :contributions, :content_provider_name, :string
    add_column :contributions, :content_provider_title, :string
    add_column :contributions, :credit_line, :string
    add_column :contributions, :color, :string
    add_column :contributions, :risk_category, :string
    add_column :contributions, :preferred_license_model, :string
    add_column :contributions, :rank, :integer, default: 3
    add_column :contributions, :collection_code, :string
    add_column :contributions, :alternate_id, :string
    add_column :contributions, :special_instructions, :text
    add_column :contributions, :call_for_image, :boolean, default: false
    add_column :contributions, :exclusive_to_getty, :boolean, default: false
    add_column :contributions, :adult_content, :boolean, default: false
    add_column :contributions, :istock_master_id, :string
  end
end

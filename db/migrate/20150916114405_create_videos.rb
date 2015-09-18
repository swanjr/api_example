class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer  :preview_id
      t.integer  :thumbnail_id
      t.string   :poster_time
      t.string   :extracted_poster_time
      t.boolean  :video_encoding_timeout, default: false
      t.string   :headline
      t.datetime :recorded_date
      t.text     :caption
      t.string   :city
      t.string   :province_state
      t.string   :country_of_shoot
      t.string   :preferred_license_model
      t.string   :copyright
      t.string   :collection_code
      t.string   :clip_length
      t.string   :frame_composition
      t.string   :frame_rate
      t.string   :frame_size
      t.string   :mastered_to_compression
      t.string   :media_format
      t.string   :original_frame_composition
      t.string   :original_frame_rate
      t.string   :original_frame_size
      t.string   :original_media_format
      t.string   :shot_speed
      t.string   :clip_type
      t.string   :original_production_title
      t.string   :language
      t.string   :content_provider_name
      t.string   :content_provider_title
      t.string   :parent_source
      t.string   :source_code
      t.string   :credit_line
      t.string   :visual_color
      t.string   :risk_category
      t.integer  :rank, default: 3
      t.string   :alternate_id
      t.string   :pixel_aspect_ratio
      t.string   :event_id
      t.string   :iptc_category
      t.string   :iptc_subject
      t.text     :iptc_subjects
      t.boolean  :audio
      t.boolean  :call_for_image, default: false
      t.boolean  :exclusive_to_getty, default: false
      t.text     :personality
      t.text     :special_instructions
      t.text     :content_warnings
      t.boolean  :adult_content
    end

    add_foreign_key :videos, :file_info,
      column: :preview_id, name: 'videos_preview_id_fk',
      on_delete: :nullify
    add_foreign_key :videos, :file_info,
      column: :thumbnail_id, name: 'videos_thumbnail_id_fk',
      on_delete: :nullify
  end
end

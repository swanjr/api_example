class Video < ActiveRecord::Base
  belongs_to :preview, foreign_key: :preview_id, class_name: 'FileInfo'
  belongs_to :thumbnail, foreign_key: :thumbnail_id, class_name: 'FileInfo'

end

class FileInfo < ActiveRecord::Base
  self.table_name = 'file_info'

  validates :name, presence: true
end

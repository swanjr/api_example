class FileUpload < ActiveRecord::Base
  validates :name, presence: true
end

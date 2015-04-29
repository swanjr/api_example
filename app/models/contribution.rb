class Contribution < ActiveRecord::Base

  TYPES = ['getty_creative_video', 'getty_editorial_video',
           'istock_editorial_video','getty_editorial_stills']
  private_constant :TYPES

  STATUSES = ['invalid_file', 'pending', 'under_review', 'under_revision',
              'rejected', 'queued', 'published']
  private_constant :STATUSES

  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  belongs_to :file_upload
  belongs_to :contributable, polymorphic: true

  validates :owner_id, presence: true
  validates :file_upload_id, presence: true
  validates :contributable_id, presence: true
  validates :contributable_type, presence: true
  validates :status, inclusion: { in: STATUSES,
    message: "%{value} is not a valid status" }
  validates :type, inclusion: { in: TYPES,
    message: "%{value} is not a valid contribution type" }

  def self.types
    TYPES
  end

  def self.statuses
    STATUSES
  end
end

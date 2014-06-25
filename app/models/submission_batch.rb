class SubmissionBatch < ActiveRecord::Base
  validates :owner_id, presence: true
  validates :name, presence: true
  validates :media_type, inclusion: { in: %w(video) }
  validates :asset_family, inclusion: { in: %w(creative editorial) }
  validates :istock, inclusion: { in: [true, false] }
  validates :status, inclusion: { in: %w(pending) }
end

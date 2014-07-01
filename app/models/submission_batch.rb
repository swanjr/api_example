class SubmissionBatch < ActiveRecord::Base
  validates :owner_id, presence: true
  validates :name, presence: true
  validates :media_type, inclusion: { in: %w(video),
    message: "%{value} is not a valid media type" }
  validates :asset_family, inclusion: { in: %w(creative editorial),
    message: "%{value} is not a valid asset family" }
  validates :istock, inclusion: { in: [true, false],
    message: "must be true or false" }
  validates :status, presence: true
end

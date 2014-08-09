class SubmissionBatch < ActiveRecord::Base
  has_paper_trail ignore: [:last_contribution_submitted_at, :created_at, :updated_at]

  validates :owner_id, presence: true
  validates :name, presence: true
  validates :media_type, inclusion: { in: %w(video),
    message: "%{value} is not a valid media type" }
  validates :asset_family, inclusion: { in: %w(creative editorial),
    message: "%{value} is not a valid asset family" }
  validates :status, presence: true

  after_initialize :init

  private

  def init
    self.istock = false if self.istock.nil?
  end
end

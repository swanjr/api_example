class SubmissionBatch < ActiveRecord::Base
  STATUSES = ['open', 'closed']

  validates :owner_id, presence: true
  validates :name, presence: true
  validates :allowed_contribution_type, presence: true
  validates :status, presence: true

  def self.statuses
    STATUSES
  end
end


class SubmissionBatch < ActiveRecord::Base
  STATUSES = ['open', 'closed']

  validates :owner_id, presence: true
  validates :name, presence: true
  validates :allowed_contribution_type, presence: true
  validates :status, presence: true

  belongs_to :user, foreign_key: :owner_id

  def self.statuses
    STATUSES
  end
end


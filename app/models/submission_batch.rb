class SubmissionBatch < ActiveRecord::Base
  STATUSES = ['open', 'closed']
  FILTER_MAPPINGS = { id: 'submission_batches.id', 
                      name: 'submission_batches.name', 
                      owner_name: 'users.username' }
  private_constant :STATUSES, :FILTER_MAPPINGS

  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  has_many :contributions

  validates :owner_id, presence: true
  validates :name, presence: true
  validates :allowed_contribution_type, inclusion: { in: Contribution.types,
    message: "%{value} is not a valid contribution type" }
  validates :status, inclusion: { in: STATUSES,
    message: "%{value} is not a valid status" }

  def self.statuses
    STATUSES
  end
end


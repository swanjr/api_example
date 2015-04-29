class SubmissionBatch < ActiveRecord::Base
  STATUSES = ['open', 'closed']
  private_constant :STATUSES


  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  has_many :contributions

  validates :owner_id, presence: true
  validates :name, presence: true
  validates :allowed_contribution_type, inclusion: { in: Contribution.types,
    message: "%{value} is not a valid contribution type" }
  validates :status, inclusion: { in: STATUSES,
    message: "%{value} is not a valid status" }

  belongs_to :user, foreign_key: :owner_id

  def self.statuses
    STATUSES
  end
end


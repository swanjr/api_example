class SubmissionBatch < ActiveRecord::Base
  STATUSES = ['open', 'closed']
  private_constant :STATUSES

  belongs_to :owner, foreign_key: :owner_id, class_name: 'User'
  has_many :contributions

  validates :owner_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :allowed_contribution_type, inclusion: { in: Contribution.types,
    message: "%{value} is not a valid contribution type" }
  validates :status, inclusion: { in: STATUSES,
    message: "%{value} is not a valid status" }
  validates :event_id,
    length: { minimum: 6, maximum: 10, message: 'ID must be 6 to 10 digits'},
    numericality: { only_integer: true, message: 'ID is not a number' },
    allow_blank: true
  validates :event_id, blank: { if: :istock?,
    message: 'ID cannot be assigned to iStock submissions'}
  validates :brief_id,
    length: { maximum: 20 },
    format: { :without => /\s/, message: 'ID must not contain spaces' },
    blank: {
      if: Proc.new { |submission| submission.getty_creative? && submission.event_id.present?},
      message: 'ID cannot be set if event ID has already been specified' },
    allow_blank: true
  validates :brief_id, blank: { if: :getty_editorial?,
    message: 'ID cannot be assigned to Getty Editorial submissions' }
  validates :brief_id, blank: { if: :istock?,
    message: 'ID cannot be assigned to iStock submission batches' }
  validates :assignment_id, blank: { if: :getty_creative?,
    message: 'ID cannot be assigned to Getty Creative submission batches' }
  validates :assignment_id, blank: { if: :istock?,
    message: 'ID cannot be assigned to iStock submission batches' }

  def self.statuses
    STATUSES
  end

  def getty_creative?
    allowed_contribution_type_contains?('getty_creative')
  end

  def getty_editorial?
    allowed_contribution_type_contains?('getty_editorial')
  end

  def istock?
    allowed_contribution_type_contains?('istock')
  end

  private

  def allowed_contribution_type_contains?(part)
    allowed_contribution_type.present? && allowed_contribution_type.include?(part)
  end
end

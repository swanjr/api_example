class CreateSubmissionBatch

  def self.create(submission_batch, owner_id)
    submission_batch.name = "Submission date: #{Date.current}" if submission_batch.name.blank?
    submission_batch.status = 'open'
    submission_batch.owner_id = owner_id
    submission_batch.save

    submission_batch
  end
end

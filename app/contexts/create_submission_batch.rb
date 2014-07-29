class CreateSubmissionBatch

  def self.create(submission_batch)
    submission_batch.name = "Submission date: #{Date.current}" if submission_batch.name.blank?
    submission_batch.status = 'pending'
    submission_batch.save

    submission_batch
  end
end

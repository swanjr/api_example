module Context
  class CreateSubmissionBatch

    def self.create(submission_batch_data)
      submission_batch = SubmissionBatch.new(submission_batch_data)
      submission_batch.name = "Submission date: #{Date.current}" if submission_batch.name.blank?
      submission_batch.status = 'pending'
      submission_batch.save

      submission_batch
    end
  end

end

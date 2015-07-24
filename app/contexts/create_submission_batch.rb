class CreateSubmissionBatch

  def self.create!(new_submission, uploader)
    uploader = User.find(uploader) if uploader.is_a?(Fixnum)

    CreateSubmissionBatch.new(new_submission, uploader).create
  end

  def initialize(new_submission, uploader)
    @submission_batch = new_submission
    @uploader = uploader.extend(Uploader)
  end

  def create
    @uploader.create_submission_batch(@submission_batch)
  end

  private

  module Uploader

    def create_submission_batch(submission_batch)
      submission_batch.name = "Submission date: #{Date.current}" if submission_batch.name.blank?
      submission_batch.status = 'open'
      submission_batch.owner = self
      submission_batch.save
    end
  end
end



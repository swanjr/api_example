class API::V1::SubmissionBatchesController < API::BaseController

  def create
    submission = SubmissionBatch.new.extend(SubmissionBatchRepresenter)
    submission.from_json(request.raw_post,
                         owner_id: current_user.id)

    CreateSubmissionBatch.create(submission)

    render_model submission, :created
  end

  def show
  end

end

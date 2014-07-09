class API::V1::SubmissionBatchesController < API::BaseController

  def create
    submission_batch = Context::CreateSubmissionBatch.create(submission_batch_params)

    respond_with :api, :v1, submission_batch
  end

  def show

  end

  private

  def submission_batch_params
    params[:submission_batch][:owner_id] = @current_user.id
    params.require('submission_batch').permit(:owner_id, :name, :media_type, :asset_family, :istock)
  end
end

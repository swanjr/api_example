class API::V1::SubmissionBatchesController < API::BaseController

  def create
    representer = SubmissionBatch.new.extend(SubmissionBatchRepresenter)
    representer.from_json(request.raw_post,
                          owner_id: current_user.id)
    CreateSubmissionBatch.create(representer)

    respond_with :api, :v1, representer
  end

  def show
  end

end

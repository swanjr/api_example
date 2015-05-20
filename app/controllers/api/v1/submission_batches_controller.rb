class API::V1::SubmissionBatchesController < API::BaseController

  def index
    query = Queries::SubmissionBatchSearch.new(limit).
      for_fields(fields).
      filter_by(filters).
      sort_by(sort_order).
      starting_at(offset)

    results = query.search.extend(SubmissionBatchRepresenter.for_collection)

    render_models results, query.offset, query.total_records
  end

  def show
    submission = SubmissionBatch.find(params[:id]).
      extend(SubmissionBatchRepresenter)

    render_model submission
  end

  def create
    submission = SubmissionBatch.new.extend(SubmissionBatchRepresenter)
    submission.from_json(request.raw_post)

    CreateSubmissionBatch.create(submission, current_user.id)

    render_model submission, :created
  end

  def update

  end
end

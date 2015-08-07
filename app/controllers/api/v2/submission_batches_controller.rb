class API::V2::SubmissionBatchesController < API::BaseController

  def index
    authorize(:read_submission_batch)

    query = Queries::SubmissionBatchSearch.new(limit).
      for_fields(fields).
      filter_by(filters).
      sort_by(sort_order).
      starting_at(offset).
      as_hash

    results = query.search

    render_list results, query.offset, query.total_records
  end

  def show
    authorize(:read_submission_batch)

    submission = SubmissionBatch.find(params[:id]).
      extend(SubmissionBatchRepresenter)

    render_model submission
  end

  def create
    authorize(:create_submission_batch)

    submission = SubmissionBatch.new.extend(SubmissionBatchRepresenter)
    submission.from_json(request.raw_post)

    CreateSubmissionBatch.create!(submission, current_user.id)

    render_model submission, :created
  end

  def update
    authorize(:update_submission_batch)

    submission = SubmissionBatch.find(params[:id]).extend(SubmissionBatchRepresenter)
    submission.from_json(request.raw_post)

    submission.save

    render_model submission
  end
end

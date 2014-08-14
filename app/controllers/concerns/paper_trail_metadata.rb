module PaperTrailMetadata
  extend ActiveSupport::Concern

  # Sets metadata for inclusion in paper_trail version table
  def info_for_paper_trail
    { :request_id => request.uuid }
  end
end

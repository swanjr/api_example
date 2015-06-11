# Module that maps raised errors to API errors
module ErrorMapper
  extend ActiveSupport::Concern

  included do

    rescue_from 'Queries::InvalidFieldError','Queries::InvalidOperatorError' do |exception|
      raise API::UnprocessableEntityError.new(exception.message, :invalid_search)
    end

  end
end

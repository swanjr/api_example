require 'rails_helper'

require 'controllers/concerns/error_mapper'

describe ErrorMapper do

  controller(ActionController::Base) do
    include ErrorMapper

    def index
      render json: '{}'
    end
  end

  it "converts Queries::InvalidFieldError to an API::UnprocessableEntityError" do
    allow(controller).to receive(:index).and_raise(Queries::InvalidFieldError.new("Field error"))

    expect{get :index, nil, format: :json}.to raise_error(
      API::UnprocessableEntityError, "Field error")
  end

  it "converts Queries::InvalidOperatorError to an API::UnprocessableEntityError" do
    allow(controller).to receive(:index).and_raise(Queries::InvalidOperatorError.new("Operator error"))

    expect{get :index, nil, format: :json}.to raise_error(
      API::UnprocessableEntityError, "Operator error")
  end
end

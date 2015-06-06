require 'rails_helper'

require 'controllers/api/base_error'
require 'exception_renderer'

describe ExceptionRenderer, type: :none do
  before(:example) do
    allow(DateTime).to receive(:now).and_return('now')
  end

  let(:exception_renderer) { ExceptionRenderer.new }

  it "renders the exception passed in if it is a child of API::BaseError" do
    env = {'action_dispatch.exception' => API::BaseError.new('Base error', 600)}
    result = exception_renderer.call(env)

    expect(result[0]).to eq(600)
    expect(result[1]).to eq({'Content-Type' => 'application/vnd.getty.error+json'})
    expect(JSON.parse(result[2][0])).to match(
      {'message' => 'Base error', 'occurred_at' => 'now', 'http_status_code' => 600, 'code' => 'internal_server_error'})
  end

  it "converts a recognized rails 4xx error to an API bad request error" do
    env = {'action_dispatch.exception' => ActionDispatch::ParamsParser::ParseError.new("Parsing error", nil)}
    result = exception_renderer.call(env)

    expect(result[0]).to eq(400)
    expect(JSON.parse(result[2][0])).to match(
      {'message' => 'Parsing error', 'occurred_at' => 'now', 'http_status_code' => 400, 'code' => 'bad_request'})
  end

  it "converts unrecognized errors to API internal server errors" do
    env = {'action_dispatch.exception' => LoadError.new}
    result = exception_renderer.call(env)

    expect(result[0]).to eq(500)
    expect(JSON.parse(result[2][0])).to match(
      {'message' => 'An unexpected error occurred.', 'occurred_at' => 'now', 'http_status_code' => 500, 'code' => 'internal_server_error'})
  end
end

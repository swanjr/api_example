require 'unit_spec_helper'

require 'action_dispatch'

require 'utils/configurable'
require 'controllers/errors/base_error'
require 'controllers/exception_renderer'

describe ExceptionRenderer do
  before(:all) do
    described_class.configure do |config|
      config.error_mappings = {'StandardError' => BaseError.new('A custom message', 111, :custom_code, 'now')}
    end
  end

  before(:each) do
    allow(DateTime).to receive(:now).and_return('now')
  end

  let(:exception_renderer) { ExceptionRenderer.new }

  it "renders the exception pass in if it is child of BaseError" do
    env = {'action_dispatch.exception' => BaseError.new('Base error', 600, :error_code)}
    result = exception_renderer.call(env)

    expect(result[0]).to eq(600)
    expect(result[1]).to eq({'Content-Type' => 'application/json'})
    expect(result[2]).to eq(
      ["{\"message\":\"Base error\",\"occurred_at\":\"now\",\"http_status_code\":600,\"code\":\"error_code\"}"])
  end

  it "renders the mapped API exception for the thrown error" do
    env = {'action_dispatch.exception' => StandardError.new("Some error")}
    result = exception_renderer.call(env)

    expect(result[0]).to eq(111)
    expect(result[2]).to eq(
      ["{\"message\":\"A custom message\",\"occurred_at\":\"now\",\"http_status_code\":111,\"code\":\"custom_code\"}"])
  end

  context "when no mapping is found" do
    it "converts a recognized rails error to an API client error" do
      env = {'action_dispatch.exception' => ActionDispatch::ParamsParser::ParseError.new("Parsing error", nil)}
      result = exception_renderer.call(env)

      expect(result[0]).to eq(400)
      expect(result[2]).to eq(
        ["{\"message\":\"Parsing error\",\"occurred_at\":\"now\",\"http_status_code\":400,\"code\":\"client_error\"}"])
    end

    it "converts unrecognized errors to API internal server errors" do
      env = {'action_dispatch.exception' => LoadError.new}
      result = exception_renderer.call(env)

      expect(result[0]).to eq(500)
      expect(result[2]).to eq(
        ["{\"message\":\"Internal server error\",\"occurred_at\":\"now\",\"http_status_code\":500,\"code\":\"internal_server_error\"}"])
    end
  end
end

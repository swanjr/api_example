require 'unit_spec_helper'

require 'utils/configurable'
require 'security/getty_token_analyzer'
require 'models/security/base_token'
require 'models/security/getty_token'

describe Security::GettyToken do
  before(:all) do
    described_class.configure do |config|
      config.endpoint = 'www.server.com/api/create_session'
      config.auth_system_id = '100'
      config.auth_system_password = 'system_password'
    end
  end

  let(:valid_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3' }
  let(:invalid_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9Pqo=|3' }
  let(:expires_at) { DateTime.new(2030, 1, 1) }
  let(:account_id) { '314' }
  let(:system_id) { '100' }

  before(:each) do
    @analyzer = instance_double('Security::GettyTokenAnalyzer')
    allow(@analyzer).to receive(:authentic?).and_return(true)
    allow(@analyzer).to receive(:expired?).and_return(false)
    allow(@analyzer).to receive(:expires_at).and_return(expires_at)
    allow(@analyzer).to receive(:account_id).and_return(account_id)
    allow(@analyzer).to receive(:system_id).and_return(system_id)
    allow(Security::GettyTokenAnalyzer).to receive(:new).and_return(@analyzer)
  end

  it "can parse compound token values" do
    originating_token = 'eXSYG+c51DgfrNzkXBM7/oYdN4WsO1WXQm+0CCmt1QtjYuw67kNO1hbgC9GqwxStgvDGrUcF3mUg4l4zQQBVewz30WBZ8dhHkoZjVV5bUR2Ourz13Ti+VKgODt6BDLXZNtF9dwBxX8mfFZdRIrDqLqRsygAfShNKdHgfdWuZqis=|77u/RUY4dFFVNndrMDJyekxFTlFkNi8KMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3'
    caller_token = 'HSOriXzG6BnCCQ7N/XoIjMxYS9Omy6FVW2rXkKRlIEB3/pp7XVnRz4quMlS5MHg381Z0LFdAT7Sqrr2uhTSX8dCGhcV4pB4tZMTrRe1dzg/jevb3eUwt5OUltg8HOlr2z5nixXmYoaUyT7VsE0ADnnn7Hl03V+1TG1movp0hF80=|77u/M3RURXhUZ0doendHQ1VDYzA0VmoKMTAwMAoKNDBNSkJBPT0KQUdxOUl3PT0KMAoKMTEuMjIuMzMuNDQKMAoKQUJDTU5nPT0K|3'
    token = "#{originating_token}##{caller_token}"

    token = described_class.new(token)

    expect(token.value).to eq(originating_token)
    expect(token.caller_token).to eq(caller_token)
  end

  describe ".new" do
    context "when token is valid" do
      it "returns a valid token object" do
        token = Security::GettyToken.new(valid_token)

        expect(token.valid?).to be(true)
        expect(token.value).to eq(valid_token)
        expect(token.account_id).to eq(account_id)
        expect(token.expires_at).to eq(expires_at)
      end
    end

    context "when token is invalid" do
      it "returns invalid token object" do 
        allow(@analyzer).to receive(:authentic?).and_return(false)
        token = Security::GettyToken.new(invalid_token)

        expect(token.valid?).to be(false)
        expect(token.value).to eq(invalid_token)
        expect(token.account_id).to eq(account_id)
        expect(token.expires_at).to eq(expires_at)
      end
    end
  end

  describe ".create" do
    context "when credentials are valid" do

      before(:each) do
        response = { "ResponseHeader" => { "Status" => "success" },
                      "CreateSessionResult" => {
                        "Token" => valid_token,
                        "TokenDurationMinutes" => "30" }
        }.to_json
        allow(RestClient).to receive(:post).and_return(response)
      end

      it "calls the Connect CreateSession service" do
        username = 'johndoe'
        password = 'pwd'

        request = {
          :RequestHeader => {
            :Token => ""
          },
          :CreateSessionRequestBody => {
            :SystemId => described_class.config.auth_system_id,
            :SystemPassword => described_class.config.auth_system_password,
            :UserName => username,
            :UserPassword => password
          }
        }.to_json
        expect(RestClient).to receive(:post).with(described_class.config.endpoint, request, {'Content-Type' => 'application/json'})

        Security::GettyToken.create(username, password)
      end

      it "returns a valid GettyToken" do
        token = Security::GettyToken.create('johndoe', 'pwd')

        expect(token.account_id).to eq(account_id)
        expect(token.value).to eq(valid_token)
        expect(token.expires_at).to eq(expires_at)
      end
    end

    context "when credentials are invalid" do
      before(:each) do
        response = {
          "ResponseHeader" => { "Status" => "failed" }
        }.to_json
        allow(RestClient).to receive(:post).and_return(response)
      end

      it "returns nil" do 
        token = Security::GettyToken.create('johndoe', 'wrong pwd')

        expect(token).to be(nil)
      end
    end

    it "throws a TokenException if an error occurs while calling CreateSession" do
      allow(RestClient).to receive(:post).and_raise(RestClient::Exception.new('Service error'))

      expect{ Security::GettyToken.create('johndoe', 'wrong pwd') }.to raise_error(Security::TokenError)
    end
  end

  describe "#valid?" do
    let(:getty_token) { described_class.new(valid_token) }

    it "returns true when token is valid" do
      expect(getty_token.valid?).to be(true)
    end

    it "returns false when token is not authentic" do
      allow(@analyzer).to receive(:authentic?).and_return(false)
      expect(getty_token.valid?).to be(false)
    end

    it "returns false when token is expired" do
      allow(@analyzer).to receive(:expired?).and_return(true)
      expect(getty_token.valid?).to be(false)
    end

    it "returns false when system id does not match" do
      allow(@analyzer).to receive(:system_id).and_return(-1)
      expect(getty_token.valid?).to be(false)
    end
  end
end

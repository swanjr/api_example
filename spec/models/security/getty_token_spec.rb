require 'unit_spec_helper'

require 'models/security/base_token'
require 'models/security/getty_token'

AUTH_SYSTEM_ID = 'system id'
AUTH_SYSTEM_PASSWORD = 'system password'
CREATE_SESSION_ENDPOINT = 'www.server.com/api/create_session'

describe Security::GettyToken do

  let(:token_key) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3' }
  let(:duration) { '15' }

  describe ".create" do

    context "when credentials are valid" do
      let(:account_id) { '314' }

      before(:each) do 
        response = { "ResponseHeader" => { "Status" => "success" },
                      "CreateSessionResult" => {
                        "Token" => token_key,
                        "TokenDurationMinutes" => "#{duration}" }
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
            :SystemId => AUTH_SYSTEM_ID,
            :SystemPassword => AUTH_SYSTEM_PASSWORD,
            :UserName => username,
            :UserPassword => password
          }
        }.to_json
        expect(RestClient).to receive(:post).with(CREATE_SESSION_ENDPOINT, request, {'Content-Type' => 'application/json'})

        Security::GettyToken.create(username, password)
      end

      it "returns a valid GettyToken when credentials are valid" do
        token = Security::GettyToken.create('johndoe', 'pwd')

        expect(token.account_id).to eq(account_id)
        expect(token.key).to eq(token_key)
        expect(token.duration).to eq(duration)
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
end

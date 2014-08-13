require 'rails_helper'

describe "AuthorizedUsers API V1" do
  let(:getty_token_class) { Security::GettyToken }

  describe "POST /api/v1/authorized_user" do
    context "when sent valid credentials" do
      let!(:user) { authorize_as(:uploader) }
      let(:valid_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3' }
      let(:account_id) { '314' }
      let(:expires_at) { DateTime.new(2030, 1, 1).to_s }

      before(:example) do
        request_mock = {
          'RequestHeader' => {
            'Token' => '',
            'CoordinationId' => ''
          },
          'GetUserTokenRequestBody' => {
            'ClientIp' => '127.0.0.1',
            'EnhancedAuthenticationMode' => 0,
            'SystemId' => getty_token_class.auth_system_id,
            'SystemPassword' => getty_token_class.auth_system_password,
            'UserName' => user.username,
            'UserPassword' => 'password'
          }
        }.to_json

        response_mock = { 'ResponseHeader' => { 'Status' => 'success' },
                    'GetUserTokenResponseBody' => {
                      'NonSecureToken' => {
                        'Token' => valid_token,
                      }
                    }
                  }.to_json
        stub_request(:post, getty_token_class.get_user_token_endpoint).
          with(:body => request_mock, :headers => {'Content-Type' => 'application/json'}).
          to_return(:status => 200, :body => response_mock)

        post '/api/v1/authorized_users', {username: user.username, password: 'password'}.to_json
      end

      it "returns status 201" do
        expect(response.status).to eq(201)
      end

      it "returns user with token" do
        expect(json['id']).to eq(user.id)
        expect(json['account_id']).to eq(user.account_id)
        expect(json['username']).to eq(user.username)
        expect(json['token']).to eq(valid_token)
        expect(json['expires_at']).to eq(expires_at)
      end
    end

    context "when sent invalid credentials" do
      before(:example) do
        request_mock = {
          'RequestHeader' => {
            'Token' => '',
            'CoordinationId' => ''
          },
          'GetUserTokenRequestBody' => {
            'ClientIp' => '127.0.0.1',
            'EnhancedAuthenticationMode' => 0,
            'SystemId' => getty_token_class.auth_system_id,
            'SystemPassword' => getty_token_class.auth_system_password,
            'UserName' => 'johndoe',
            'UserPassword' => 'bad_password'
          }
        }.to_json

        response_mock = {
          "ResponseHeader" => { 
            "Status" => "error",
            "StatusList" => [{
              "Type" => "Error",
              "Code" => "InvalidUsernameOrPassword",
              "Message" => "Invalid username or password."
            }],
            "CreateSessionResult" => nil
          }
        }.to_json

        stub_request(:post, getty_token_class.get_user_token_endpoint).
          with(:body => request_mock, :headers => {'Content-Type' => 'application/json'}).
          to_return(:status => 200, :body => response_mock)

        post '/api/v1/authorized_users', {username: 'johndoe', password: 'bad_password'}.to_json
      end

      it "returns status 401" do
        expect(response.status).to eq(401)
      end

      it "returns an error message" do
        expect(json['message']).not_to be_nil
      end

      it "returns invalid credentials error code" do
        expect(json['code']).to eq('authentication_failure')
      end
    end
  end
end

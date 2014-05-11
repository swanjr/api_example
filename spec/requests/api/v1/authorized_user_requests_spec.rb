require 'spec_helper'

describe "AuthorizedUsers API V1", :integration do

  context "when sent valid credentials" do
    let(:valid_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3' }
    let(:account_id) { '314' }
    let(:duration) { 15 }

    let(:user) { FactoryGirl.create(:user, :account_id => account_id) }

    before(:each) do
      request_mock = {
        RequestHeader: {
          Token: ""
        },
        CreateSessionRequestBody: {
          SystemId:       AUTH_SYSTEM_ID,
          SystemPassword: AUTH_SYSTEM_PASSWORD,
          UserName:       user.username,
          UserPassword:   'password'
        }
      }.to_json

      response_mock = { "ResponseHeader" => { "Status" => "success" },
                    "CreateSessionResult" => {
                      "Token" => valid_token,
                      "TokenDurationMinutes" => duration }
      }.to_json

      stub_request(:post, CREATE_SESSION_ENDPOINT).
        with(:body => request_mock, :headers => {'Content-Type' => 'application/json'}).
        to_return(:status => 200, :body => response_mock)

      post '/api/v1/authorized_users', {username: user.username, password: 'password'}
    end

    it { expect(response.status).to eq(201) }

    it { expect(json['username']).to eq(user.username) }

    it { expect(json['token']).to eq(valid_token) }

    it { expect(json['duration']).to eq(duration) }
  end

  context "when sent invalid credentials" do
    before(:each) do
      request_mock = {
        RequestHeader: {
          Token: ""
        },
        CreateSessionRequestBody: {
          SystemId:       AUTH_SYSTEM_ID,
          SystemPassword: AUTH_SYSTEM_PASSWORD,
          UserName:       'johndoe',
          UserPassword:   'bad_password'
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

      stub_request(:post, CREATE_SESSION_ENDPOINT).
        with(:body => request_mock, :headers => {'Content-Type' => 'application/json'}).
        to_return(:status => 200, :body => response_mock)

      post '/api/v1/authorized_users', {username: 'johndoe', password: 'bad_password'}
    end

    it { expect(response.status).to eq(401) }

    it { expect(json['message']).to_not be_nil }

    it { expect(json['code']).to eq('invalid_credentials') }
  end
end

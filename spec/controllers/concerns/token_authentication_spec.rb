require 'rails_helper'

describe TokenAuthentication do
  let(:user) { FactoryGirl.build(:user) }

  before do
    allow(User).to receive(:for_account_number).and_return(user)
  end

  let(:valid_token) { 'JYE3gNbvSv5GH3dAp2QnYAicNf407Yh3z1f7RJi3BNPcD1j4JwRMPutk/9pe01kg0urM2fzIPLNKoCRhuAwwbUoPeQCmmEFZTZw09Sq1MfadjKKL4TJKb5SLvySAvTtG2XUiXNI53oRzzaq7s3gU53cDIiNy9CJbCpLBtoAshDg=|77u/dkZYTnQ5OHlyZmt0dXZnR3lCc1UKMTUyMAo0NzUyOTM5CmpFTUhCUT09CkFHcTlJdz09CjAKCjExLjIyLjMzLjQ0CjAKCkFCQ01OZz09Cgo=|3' }
  let(:invalid_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9Pqo=|3' }
  let(:wrong_system_id_token) { 'pBHCf7Rf9gpGp7gUZ5C0Svg9NHO0SXHWv+5bke0WL+K++IOYJnYnCjGC/ZYs9hfxi/0yPNTqDkpcLRkPUwespILojcQmObp093UANhqrhoVnZQ+38Pbenejmos2hSb/UkGcvULQIalZ6dLdgt544rj6lJkTlCftDzCOgSKPoCjQ=|77u/dk11bTBUQitNV2k4MWJ2THJhUisKMAoKem5FT0JBPT0KQUdxOUl3PT0KMAoKMTEuMjIuMzMuNDQKMAoKQUJDTU5nPT0K|3' }
  let(:expired_token) { 'fsc8XeAFaufBr8HIFNiXSQHpgzGd3LdbeSR2H/CK9rg4dQqs3hta/Uje2w8WNOss9ChwSL8x5RgaORgIy9JZYVYR1Cym2uOHDywQ/qsU1ivba6TntcGXGGZYkh5qvwfO16GjqSeMryYZb5e1Q1JxEnj47jWSKhjUmCf91+EzaDM=|77u/dzYyb0Rjb2tEeFpjZW9teGhOdzQKMTAwCjMxNAo0ME1KQkE9PQpBQUFBQUE9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3' }
  let(:tampered_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9Pqo=|3' }
  let(:system_token) { 'j9FKNwFcPNuFPc0jgXlkm47IV+X2XQWMn2iMF7pMw7hURNTCteYjBZGX8eiN6AspEb5d2uviue5mlhyRUoW5vTNIml66ZP9A9Kmm/LPub8L6FzTQO8UngVj14u+Koq1s49tUvMt8PYSEL9KY/D27TQUr9yEJfZ4yAWA4Jzd5knE=|77u/Z2ZYNVpkSHNpTC9FaXpNdFVPeTgKMTUyMAoKV2owc0J3PT0KWWtRc0J3PT0KMAoKCjAKMTUyMAoKMTUyMAowCgo=|3' }

  controller(API::BaseController) do
    include TokenAuthentication

    def index
      render json: '{foo: "bar"}'
    end
  end

  describe "#restrict_access" do

    context "finds the token" do
      it "with header credentials" do
        token = ActionController::HttpAuthentication::Token.
          encode_credentials(valid_token, :coordination_id => 'ABCD')
        request.env['HTTP_AUTHORIZATION'] = token

        expect { get :index, nil, format: :json }.to_not raise_error
      end

      it "with cookie credentials" do
        request.cookies["auth"] = valid_token

        expect { get :index, nil, format: :json }.to_not raise_error
      end

      it "with request body credentials" do
        body = { :request_header => { :token => valid_token, 
                                      :coordination_id => "ABCD" } }

        expect { get :index, body, format: :json }.to_not raise_error
      end
    end

    context "when token is valid" do
      before do
        token = ActionController::HttpAuthentication::Token.
          encode_credentials(valid_token, :coordination_id => 'ABCD')
        request.env['HTTP_AUTHORIZATION'] = token
      end

      it "set current user" do
        get :index, nil, format: :json

        expect(assigns(:current_user)).to be(user)
      end

      it "set the auth_token" do
        get :index, nil, format: :json

        expect(assigns(:auth_token)).to eq(valid_token)
      end

      it "set the user's cookies" do
        get :index, nil, format: :json

        expect(response.cookies['auth']).to eq(valid_token)
        expect(response.cookies['account_number']).to eq(user.account_number)
        expect(response.cookies['user_id']).to eq(user.id)
        expect(response.cookies['username']).to eq(user.username)
      end

    end

    context "when no token is provided" do
      it "raise auth_token_missing AuthenticationError" do
        expect { get :index, nil, format: :json }.to raise_error { |error|
          expect(error).to be_a(API::AuthenticationError)
          expect(error.code).to equal(:auth_token_missing)
        }
      end
    end

    context "when token is invalid" do
      before do
        token = ActionController::HttpAuthentication::Token.
          encode_credentials(invalid_token, :coordination_id => 'ABCD')
        request.env['HTTP_AUTHORIZATION'] = token
      end

      it "raise an authentication_failure AuthenticationError" do
        expect { get :index, nil, format: :json }.to raise_error { |error|
          expect(error).to be_a(API::AuthenticationError)
          expect(error.code).to equal(:authentication_failure)
        }
      end
    end

    context "when the user account cannot be found" do
      before do
        token = ActionController::HttpAuthentication::Token.
          encode_credentials(valid_token, :coordination_id => 'ABCD')
        request.env['HTTP_AUTHORIZATION'] = token
      end

      it "raise an account_not_found AuthenticationError" do
        allow(Security::GettyToken).to receive(:new).
          and_return(Security::GettyToken.new(valid_token))
        allow(User).to receive(:for_account_number).and_return(nil)

        expect { get :index, nil, format: :json }.to raise_error { |error|
          expect(error).to be_a(API::AuthenticationError)
          expect(error.code).to equal(:account_not_found)
        }
      end
    end

    context "when the token is expired" do
      before do
        token = ActionController::HttpAuthentication::Token.
          encode_credentials(expired_token, :coordination_id => 'ABCD')
        request.env['HTTP_AUTHORIZATION'] = token
      end

      it "renew the token" do
        expect(Security::GettyToken).to receive(:renew).
          and_return(Security::GettyToken.new(valid_token))

        get :index, nil, :format => :json
      end

      it "sets the auth cookie to the renewed token value" do
        allow(Security::GettyToken).to receive(:renew).
          and_return(Security::GettyToken.new(valid_token))

        get :index, nil, :format => :json

        expect(response.cookies["auth"]).to eql(valid_token)
      end

      it "raise an authentication_failure AuthenticationError if it can't be renewed" do
        allow(Security::GettyToken).to receive(:renew).
          and_return(nil)

        expect { get :index, nil, format: :json }.to raise_error { |error|
          expect(error).to be_a(API::AuthenticationError)
          expect(error.code).to equal(:authentication_failure)
        }
      end
    end
  end
end

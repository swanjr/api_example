require 'rails_helper'

describe API::V1::HealthCheckController do

  describe "GET#show /api/v1/health_check"do
    before do
      stub_for_isolation(:post,
                         Security::GettyToken.config[:get_system_token_endpoint])
    end

    it "returns a JSON hash containing the database's status" do
      get '/api/v1/health_check', nil

      expect(response).to have_status(:ok)
      expect(json['database']).to_not be_nil
      expect(json['database']['status']).to eq('ok')
    end
  end
end

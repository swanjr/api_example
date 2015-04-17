require 'rails_helper'

describe API::V1::HealthCheckController, :integration do

  describe "GET 'show'" do
    it "returns a JSON hash containing the database's status" do

      get '/api/v1/health_check', nil

      expect(response).to have_status(:ok)
      expect(json['database']).to_not be_nil
      expect(json['database']['status']).to eq('ok')
    end
  end
end

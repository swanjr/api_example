require 'rails_helper'

describe API::V2::HealthCheckController do

  describe "GET#show" do
    before do
      valid_token = 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3'

      stub_for_isolation(:post,
                         Security::GettyToken.config[:get_system_token_endpoint],
                         { 'ResponseHeader' => {'Status' => 'success' },
                            'GetSystemTokenResponseBody' => {'Token' => valid_token}}.to_json)
    end

    context "connects to MySQL" do
      it "returns a status of 'ok' if all checks are successful" do
        get api_v2_health_check_path, nil

        expect(response).to have_status(:ok)
        expect(json['database']['status']).to eq('ok')
      end

      it "returns a status of 'error' if any check is unsuccessful" do
        allow(SubmissionBatch).to receive(:last).and_raise(StandardError)
        get api_v2_health_check_path, nil

        expect(json['database']['status']).to eq('error')
        expect(json['database']['message']).to_not be_nil
      end
    end

    context "connects to STS" do
      it "returns a status of 'ok' if all checks are successful" do
        get api_v2_health_check_path, nil

        expect(json['sts']['status']).to eq('ok')
      end

      it "returns a status of 'error' if any check is unsuccessful" do
        allow(Security::GettyToken).to receive(:create_system_token).and_raise(StandardError)
        get api_v2_health_check_path, nil

        expect(json['sts']['status']).to eq('error')
        expect(json['sts']['message']).to_not be_nil
      end
    end
  end
end

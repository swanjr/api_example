require 'rails_helper'

describe "SubmissionBatches API V1" do
  let!(:user) { authorize_as(:uploader) }
  let(:submission_attrs) { FactoryGirl.attributes_for(:submission_batch) }

  describe "POST /api/v1/submission_batches" do
    context 'with a valid request' do

      before(:example) do
        post '/api/v1/submission_batches',
          {:submission_batch => submission_attrs}, http_authorization_header
      end

      it "returns status 201" do
        expect(response.status).to eq(201)
      end

      it "returns created submission" do
        expect(json['id']).not_to be_nil
        expect(json['owner_id']).to eq(user.id)
        expect(json['name']).to eq(submission_attrs[:name])
        expect(json['media_type']).to eq(submission_attrs[:media_type])
        expect(json['asset_family']).to eq(submission_attrs[:asset_family])
        expect(json['istock']).to eq(submission_attrs[:istock])
        expect(json['status']).to eq('pending')
        expect(json['last_contribution_submitted_at']).to be_nil
      end
    end

    context 'with an invalid request' do
      before(:example) do
        invalid_params = submission_attrs
        invalid_params.delete(:media_type)
        post '/api/v1/submission_batches',
          {:submission_batch => invalid_params}, http_authorization_header
      end

      it "returns status 422" do
        expect(response.status).to eq(422)
      end

      it "returns an error message" do
        expect(json['messages']).not_to be_empty
      end
    end
  end

end

require 'rails_helper'

describe "SubmissionBatches API V1", :integration do
  let!(:user) { authorize_as(:uploader) }
  let(:submission_attrs) { FactoryGirl.attributes_for(:submission_batch) }

  describe "GET /api/v1/submission_batches" do

  end

  describe "GET /api/v1/submission_batches/:id" do
    context 'when submission found' do
      let!(:submission) { SubmissionBatch.create(submission_attrs) }

      before do
        get "/api/v1/submission_batches/#{submission.id}", {},
          http_authorization_header
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "returns created submission" do
        expect(json['id']).to be(submission.id)
      end
    end

    context 'when submission not found' do
      before do
        get "/api/v1/submission_batches/-1", {},
          http_authorization_header
      end

      it "returns status 404" do
        expect(response.status).to eq(404)
      end

      it "does not return a submission" do
        expect(json['id']).to be_nil
      end
    end
  end

  describe "POST /api/v1/submission_batches" do
    context 'with a valid request' do

      before do
        post '/api/v1/submission_batches',
          submission_attrs.to_json, http_authorization_header
      end

      it "returns status 201" do
        expect(response.status).to eq(201)
      end

      it "returns created submission" do
        expect(json['id']).not_to be_nil
      end
    end

    context 'with an invalid request' do
      before do
        invalid_params = submission_attrs
        invalid_params.delete(:allowed_contribution_type)

        post '/api/v1/submission_batches',
          invalid_params.to_json, http_authorization_header
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

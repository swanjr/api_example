require 'rails_helper'

describe "SubmissionBatches API V1" do
  let!(:owner) { authorize_as(:uploader) }

  describe "GET#index /api/v1/submission_batches" do
    let(:records) { @records }

    before do
      @records = []
      @records << FactoryGirl.create(:submission_batch, name: 'Average', owner_id: owner.id)
      @records << FactoryGirl.create(:submission_batch, name: 'Average', owner_id: owner.id)
      @records << FactoryGirl.create(:submission_batch, name: 'Awesome', owner_id: owner.id)
      @records << FactoryGirl.create(:submission_batch, name: 'Very poor', owner_id: owner.id)
      @records << FactoryGirl.create(:submission_batch, name: 'Poor', owner_id: owner.id)
    end

    it "returns all submissions" do
      get "/api/v1/submission_batches", {},
        http_authorization_header

      expect(response).to have_status(:ok)
      expect(json.count).to eq(records.size)
    end

    it "returns sorted records according to the provided sort order" do
      get "/api/v1/submission_batches?sort=name,-id", {},
        http_authorization_header

      expect(response).to have_status(:ok)
      expect(json.count).to be(5)
      expect(json[0]['name']).to eql(records[1].name)
      expect(json[0]['id']).to eql(records[1].id)
      expect(json[1]['name']).to eql(records[0].name)
      expect(json[1]['id']).to eql(records[0].id)
      expect(json[2]['name']).to eql(records[2].name)
      expect(json[3]['name']).to eql(records[4].name)
      expect(json[4]['name']).to eql(records[3].name)
    end

    it "returns the specified limit of records starting at the provided offset" do
      get "/api/v1/submission_batches?limit=3&offset=2", {},
        http_authorization_header

      expect(response).to have_status(:ok)
      expect(json.count).to be(3)
      expect(json[0]['id']).to eql(records[2].id)
      expect(json[1]['id']).to eql(records[3].id)
      expect(json[2]['id']).to eql(records[4].id)
    end


    it "returns only the specified fields" do
      get "/api/v1/submission_batches?fields=id,owner_username", {},
        http_authorization_header

      expect(response).to have_status(:ok)
      expect(json.count).to be(5)
      expect(json[0]['id']).to eql(records[0].id)
      expect(json[0]['owner_username']).to eql(records[0].owner.username)
      expect(json[0]['name']).to be_nil
    end

    it "returns a filtered list of records" do
      get "/api/v1/submission_batches?filters=name=A*,id>#{records[0].id}", {},
        http_authorization_header

      expect(response).to have_status(:ok)
      expect(json.count).to be(2)
      expect(json[0]['name']).to eql(records[1].name)
    end
  end

  describe "GET#show /api/v1/submission_batches/:id" do
    context 'when submission found' do
      let!(:submission) { FactoryGirl.create(:submission_batch, owner_id: owner.id) }

      it "returns created submission" do
        get "/api/v1/submission_batches/#{submission.id}", {},
          http_authorization_header

        expect(response).to have_status(:ok)
        expect(json['id']).to be(submission.id)
        expect(json['owner_id']).to be(owner.id)
      end
    end

    context 'when submission not found' do
      it "does not return a submission" do
        get "/api/v1/submission_batches/-1", {},
          http_authorization_header

        expect(response).to have_status(:not_found)
        expect(json['id']).to be_nil
      end
    end
  end

  describe "POST#create /api/v1/submission_batches" do
    let(:submission_attrs) { FactoryGirl.attributes_for(:submission_batch) }

    context 'with valid data' do
      it "returns created submission" do
        post '/api/v1/submission_batches',
          submission_attrs.to_json, http_authorization_header

        expect(response).to have_status(:created)
        expect(json['id']).not_to be_nil
      end
    end

    context 'with invalid data' do
      it "returns an error message" do
        invalid_params = submission_attrs
        invalid_params.delete(:allowed_contribution_type)

        post '/api/v1/submission_batches',
          invalid_params.to_json, http_authorization_header

        expect(response).to have_status(:unprocessable_entity)
        expect(json['messages']).not_to be_empty
      end
    end
  end
end

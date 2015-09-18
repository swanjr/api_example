require 'rails_helper'

describe "SubmissionBatches API V2" do

  describe "GET#index" do
    let!(:owner) { user_authorized_to(:read_submission_batch) }
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
      get api_v2_submission_batches_path, {},
        http_authorization_header

      expect(response).to have_status(:ok)
      expect(json['items'].size).to eq(records.size)
      expect(json['offset']).to be(0)
      expect(json['item_count']).to be(records.size)
      expect(json['total_items']).to be(records.size)
    end

    it "returns sorted records according to the provided sort order" do
      get "#{api_v2_submission_batches_path}?sort=name,-id", {},
        http_authorization_header

      expect(response).to have_status(:ok)

      results  = json['items']
      expect(results.count).to eq(records.size)
      expect(results[0]['name']).to eql(records[1].name)
      expect(results[0]['id']).to eql(records[1].id)
      expect(results[1]['name']).to eql(records[0].name)
      expect(results[1]['id']).to eql(records[0].id)
      expect(results[2]['name']).to eql(records[2].name)
      expect(results[3]['name']).to eql(records[4].name)
      expect(results[4]['name']).to eql(records[3].name)
    end

    it "returns the specified limit of records starting at the provided offset" do
      get "#{api_v2_submission_batches_path}?limit=3&offset=2", {},
        http_authorization_header

      expect(response).to have_status(:ok)

      results  = json['items']
      expect(json['offset']).to be(2)
      expect(json['item_count']).to be(3)
      expect(json['total_items']).to be(records.size)
      expect(results.count).to be(3)
      expect(results[0]['id']).to eql(records[2].id)
      expect(results[1]['id']).to eql(records[3].id)
      expect(results[2]['id']).to eql(records[4].id)
    end

    it "returns only the specified fields" do
      get "#{api_v2_submission_batches_path}?fields=id,owner_username", {},
        http_authorization_header

      expect(response).to have_status(:ok)

      results  = json['items']

      expect(results.count).to be(5)
      expect(results[0]['id']).to eql(records[0].id)
      expect(results[0]['owner_username']).to eql(records[0].owner.username)
      expect(results[0]['name']).to be_nil
    end

    it "returns a filtered list of records" do
      get "#{api_v2_submission_batches_path}?filters=name~A*,id>#{records[0].id}", {},
        http_authorization_header

      expect(response).to have_status(:ok)

      results  = json['items']
      expect(results.count).to be(2)
      expect(results[0]['name']).to eql(records[1].name)
    end
  end

  describe "GET#show" do
    let!(:owner) { user_authorized_to(:read_submission_batch) }

    context 'when submission found' do
      let!(:submission) { FactoryGirl.create(:submission_batch, owner_id: owner.id) }

      it "returns created submission" do
        get api_v2_submission_batch_path(submission.id), {},
          http_authorization_header

        expect(response).to have_status(:ok)
        expect(json['id']).to be(submission.id)
        expect(json['owner_id']).to be(owner.id)
      end
    end

    context 'when submission not found' do
      it "does not return a submission" do
        get api_v2_submission_batch_path(-1), {},
          http_authorization_header

        expect(response).to have_status(:not_found)
        expect(json['id']).to be_nil
      end
    end
  end

  describe "POST#create" do
    let!(:owner) { user_authorized_to(:create_submission_batch) }
    let(:submission_attrs) { FactoryGirl.attributes_for(:submission_batch) }

    context 'with valid data' do
      it "returns created submission" do
        post api_v2_submission_batches_path,
          submission_attrs.to_json, http_authorization_header

        expect(response).to have_status(:created)
        expect(json['id']).not_to be_nil
      end
    end

    context 'with invalid data' do
      it "returns an error message" do
        invalid_params = submission_attrs
        invalid_params.delete(:allowed_contribution_type)

        post api_v2_submission_batches_path,
          invalid_params.to_json, http_authorization_header

        expect(response).to have_status(:unprocessable_entity)
        expect(json['messages']).not_to be_empty
      end
    end
  end

  describe "PUT#update" do
    let!(:owner) { user_authorized_to(:update_submission_batch) }
    let(:submission_attrs) { {
      name: "John's Submission Batch",
      status: 'closed',
      owner_id: '-1',
      allowed_contribution_type: 'istock_creative_video'
    } }
    let(:submission) { FactoryGirl.create(:submission_batch, owner: owner) }

    context 'with valid data' do
      it "returns the updated submission" do
        puts owner.inspect
        put api_v2_submission_batch_path(submission.id),
          submission_attrs.to_json, http_authorization_header

        expect(response).to have_status(:ok)
        expect(json['id']).to be(submission.id)
        expect(json['name']).to eql(submission_attrs[:name])
        expect(json['status']).to eql(submission.status)
        expect(json['owner_id']).to eql(submission.owner_id)
        expect(json['allowed_contribution_type']).to eql(submission.allowed_contribution_type)
      end
    end

    context 'with invalid data' do
      it "returns an unprocessable_entity error message" do
        invalid_params = submission_attrs
        invalid_params[:name] = ''

        put api_v2_submission_batch_path(submission.id),
          invalid_params.to_json, http_authorization_header

        expect(response).to have_status(:unprocessable_entity)
        expect(json['messages']).not_to be_empty
      end
    end

    context "with an invalid submission id" do
      it "returns a not found error message" do
        put api_v2_submission_batch_path(-1),
          submission_attrs.to_json, http_authorization_header

        expect(response).to have_status(:not_found)
        expect(json['message']).not_to be_nil
      end
    end
  end
end

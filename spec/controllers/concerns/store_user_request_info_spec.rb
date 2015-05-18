require 'rails_helper'

require 'controllers/concerns/store_user_request_info'

describe StoreUserRequestInfo do
  let(:user) { FactoryGirl.build(:user) }
  let(:token) { 'token_str' }

  controller(API::BaseController) do
    include StoreUserRequestInfo

    skip_before_action :restrict_access

    def index
      render json: '{foo: "bar"}'
    end

    def current_user; end
    def auth_token; end
  end

  describe "#store_info" do
    before(:example) do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:auth_token).and_return(token)
    end

    after(:example) do
      #Simulate RequestStore's middleware
      RequestStore.clear!
    end

    it "stores the user's request info" do
      get :index, nil, format: :json

      expect(RequestStore.store[:request_id]).to eq(request.uuid)
      expect(RequestStore.store[:remote_ip]).to eq(request.remote_ip)
      expect(RequestStore.store[:user_agent]).to eq(request.user_agent)
    end

    it "stores the user's account info and token" do
      get :index, nil, format: :json

      expect(RequestStore.store[:username]).to eq(user.username)
      expect(RequestStore.store[:user_id]).to eq(user.id)
      expect(RequestStore.store[:auth_token]).to eq(token)
    end

    context "when current_user is not set" do
      before(:example) do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it "does not store the user's account info and token" do
        get :index, nil, format: :json

        expect(RequestStore.store[:username]).to eq(nil)
        expect(RequestStore.store[:user_id]).to eq(nil)
        expect(RequestStore.store[:auth_token]).to eq(nil)
      end
    end
  end
end

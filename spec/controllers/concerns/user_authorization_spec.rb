require 'rails_helper'

require 'controllers/concerns/user_authorization'

describe UserAuthorization do
  let(:user) { FactoryGirl.build(:user) }

  controller(API::MetalController) do
    include UserAuthorization

    before_action :skip_authorization, only: [:show]

    def index
      authorize("some_permission")
      render json: '{foo: "bar"}'
    end

    def show
      render json: '{foo: "bar"}'
    end

    def create
      render json: '{foo: "bar"}'
    end

    def current_user; end
  end

  it "raises an AuthorizationNotVerfiedError if authorize is not called or skipped" do
    expect { post :create, nil, format: :json }.to raise_error(AuthorizationNotVerifiedError)
  end

  describe "#authorize" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    it "raises an API::AuthorizationError if the user does not have access" do
      expect { get :index, nil, format: :json }.to raise_error(API::AuthorizationError)
    end

    it "does not raise an error if the user has access" do
      expect(user).to receive(:has_permission?).with('some_permission').and_return(true)

      expect { get :index, nil, format: :json }.to_not raise_error
    end
  end

  describe "#skip_authorization" do
    it "does not raise an AuthorizationNotVerifiedError if skip_authorization is called" do
      expect { get :show, id: 1, format: :json }.to_not raise_error
    end
  end
end

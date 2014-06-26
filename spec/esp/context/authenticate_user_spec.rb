require 'active_record_helper'

require 'utils/configurable'
require 'models/security/getty_token'
require 'models/user'
require 'esp/context/authenticate_user'
require 'esp/base_error'
require 'esp/unknown_user_error'

describe Context::AuthenticateUser do
  let(:token_mock) { instance_double('Security::GettyToken') }
  let(:user) { described_class::AuthorizedUser.new(
    :username => 'johndoe',
    :account_id =>1) }

  before(:each) do
    allow(token_mock).to receive(:account_id).and_return(user.account_id)

    allow(described_class::AuthorizedUser).to receive(:find_by_account_id).and_return(user)
  end

  describe "#authenticate" do
    context "with valid credentials" do

      before(:each) do
        allow(Security::GettyToken).to receive(:create).and_return(token_mock)

        allow(user).to receive(:account_id)
        allow(user).to receive(:save!)
      end

      it "creates a valid token" do
        expect(Security::GettyToken).to receive(:create).with(user.username, 'pwd', '1.1.1.1')

        described_class.authenticate(user.username, 'pwd', '1.1.1.1')
      end

      context "when the user exists" do
        it 'successfully retrieves the user' do
          authorized_user = described_class.authenticate(nil, nil, nil)

          expect(authorized_user.username).to eq(user.username)
          expect(authorized_user.account_id).to eq(user.account_id)
        end

        it "returns an AuthorizedUser with a token" do
          authorized_user = described_class.authenticate(nil, nil, nil)

          expect(authorized_user.token).to_not be_nil
        end

        context "and the authenticated username and database username to not match" do
          it "override the database username" do
            authorized_user = described_class.authenticate('new_user', nil, nil)
            expect(authorized_user.username).to eq('new_user')
          end
        end
      end

      context "when the user does not exist" do
        it "raise an unknown user error" do
          allow(described_class::AuthorizedUser).to receive(:find_by_account_id).and_return(nil)

          expect{ described_class.authenticate(nil, nil, nil) }.to raise_error(UnknownUserError)
        end
      end

    end

    context "with invalid credentials" do
      before(:each) do
        allow(Security::GettyToken).to receive(:create).and_return(nil)
      end

      it "returns nil" do
        unauthorized_user = described_class.authenticate('user', 'bad_password', '1.1.1.1')

        expect(unauthorized_user).to be_nil
      end
    end
  end

  describe "#authenticate_token" do
    context('returns an AuthorizedUser') do
      before(:each) do
        allow(Security::GettyToken).to receive(:new).and_return(token_mock)
      end

      it "returns an AuthorizedUser for a valid token" do
        allow(token_mock).to receive(:valid?).and_return(true)

        authorized_user = described_class.authenticate_token('valid_token')
        expect(authorized_user).to_not be_nil
      end

      it "returns an AuthorizedUser if token is" do
        expired_token = 'expired_token'
        allow(Security::GettyToken).to receive(:new).with(expired_token).and_return(token_mock)
        allow(Security::GettyToken).to receive(:renew).with(expired_token).and_return(token_mock)

        allow(token_mock).to receive(:valid?).and_return(false)
        allow(token_mock).to receive(:expired?).and_return(true)
        allow(token_mock).to receive(:value).and_return(expired_token)

        authorized_user = described_class.authenticate_token(expired_token)
        expect(authorized_user).to_not be_nil
      end
    end

    it "returns nil if token value parameter is nil" do
      expect(described_class.authenticate_token(nil)).to be_nil
    end

    it "returns nil if the token could not be renewed" do
      allow(Security::GettyToken).to receive(:renew).and_return(nil)
      expect(described_class.authenticate_token(nil)).to be_nil
    end
  end
end

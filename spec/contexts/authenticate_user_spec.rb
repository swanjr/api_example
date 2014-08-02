require 'active_record_helper'

require 'utils/configurable'
require 'models/security/getty_token'
require 'models/user'
require 'contexts/base_error'
require 'contexts/unknown_user_error'
require 'contexts/expired_token_error'

require 'contexts/authenticate_user'

describe AuthenticateUser do
  let(:token_mock) { instance_double('Security::GettyToken') }
  let(:user) { described_class::AuthorizedUser.new(
    :username => 'johndoe',
    :account_id =>1) }

  before(:example) do
    allow(token_mock).to receive(:account_id).and_return(user.account_id)
    allow(described_class::AuthorizedUser).to receive(:find_by_account_id).and_return(user)
  end

  describe "#authenticate" do
    context "with valid credentials" do

      before(:example) do
        allow(Security::GettyToken).to receive(:create).and_return(token_mock)
      end

      it "creates a valid token" do
        expect(Security::GettyToken).to receive(:create).with(user.username, 'pwd', '1.1.1.1')

        described_class.authenticate(user.username, 'pwd', '1.1.1.1')
      end

      context "when the user exists" do
        it 'successfully retrieves the user' do
          authorized_user = described_class.authenticate(user.username, 'pwd', '1.1.1.1')

          expect(authorized_user.username).to eq(user.username)
          expect(authorized_user.account_id).to eq(user.account_id)
        end

        it "returns an AuthorizedUser with a token" do
          authorized_user = described_class.authenticate(user.username, 'pwd', '1.1.1.1')

          expect(authorized_user.token).to_not be_nil
        end
      end

      context "when the user does not exist" do
        it "raise an unknown user error" do
          allow(described_class::AuthorizedUser).to receive(:find_by_account_id).and_return(nil)

          expect{ described_class.authenticate(user.username, 'pwd', '1.1.1.1') }.to raise_error(UnknownUserError)
        end
      end

    end

    context "with invalid credentials" do
      before(:example) do
        allow(Security::GettyToken).to receive(:create).and_return(nil)
      end

      it "returns nil" do
        unauthorized_user = described_class.authenticate('bad_username', 'bad_password', '1.1.1.1')

        expect(unauthorized_user).to be_nil
      end
    end
  end

  describe "#authenticate_token" do
    it "returns nil if token value parameter is nil" do
      expect(described_class.authenticate_token(nil)).to be_nil
    end

    it "returns an AuthorizedUser for a valid token" do
      allow(token_mock).to receive(:valid?).and_return(true)
      allow(token_mock).to receive(:expired?).and_return(false)
      allow(Security::GettyToken).to receive(:new).and_return(token_mock)

      authorized_user = described_class.authenticate_token('valid_token')
      expect(authorized_user).to_not be_nil
    end

    it "returns nil if token is not expired but invalid" do
      invalid_token = 'invalid_token'
      allow(token_mock).to receive(:valid?).and_return(false)
      allow(token_mock).to receive(:expired?).and_return(false)
      allow(Security::GettyToken).to receive(:new).with(invalid_token).and_return(token_mock)

      authorized_user = described_class.authenticate_token(invalid_token)
      expect(authorized_user).to be_nil
    end

    context "when the token is expired" do
      let(:expired_token) { 'expired_token' }

      before(:example) do
        allow(token_mock).to receive(:expired?).and_return(true)
        allow(Security::GettyToken).to receive(:new).with(expired_token).and_return(token_mock)
      end

      it "returns an AuthorizedUser if it can be renewed" do
        renewed_token_mock = instance_double('Security::GettyToken')
        allow(renewed_token_mock).to receive(:valid?).and_return(true)
        allow(renewed_token_mock).to receive(:account_id).and_return(user.account_id)
        allow(Security::GettyToken).to receive(:renew).with(token_mock).and_return(renewed_token_mock)

        authorized_user = described_class.authenticate_token(expired_token)
        expect(authorized_user).to_not be_nil
      end

      it "raises ExpiredTokenError if the token could not be renewed" do
        allow(Security::GettyToken).to receive(:renew).and_return(nil)

        expect{ described_class.authenticate_token(expired_token)}.to raise_error(ExpiredTokenError)
      end
    end
  end
end

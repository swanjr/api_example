require 'active_record_helper'

require 'models/security/getty_token'
require 'models/user'

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

      it "raises ExpiredTokenError" do
        expect{ described_class.authenticate_token(expired_token)}.to raise_error(ExpiredTokenError)
      end
    end
  end
end

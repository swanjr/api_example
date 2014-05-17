require 'unit_spec_helper'

require 'models/security/base_token'
require 'models/security/getty_token'
require 'models/user'
require 'esp/context/authenticate_user'
require 'esp/errors'

describe Context::AuthenticateUser do

  describe "#authenticate" do
    let(:token_mock) { instance_double('Security::GettyToken') }

    context "with valid credentials" do
      let(:user) { described_class::AuthorizedUser.new(
        :username => 'johndoe',
        :account_id =>1) }

      before(:each) do
        allow(token_mock).to receive(:account_id).and_return(user.account_id)
        allow(Security::GettyToken).to receive(:create).and_return(token_mock)

        allow(described_class::AuthorizedUser).to receive(:find_by_account_id).and_return(user)

        allow(user).to receive(:account_id)
        allow(user).to receive(:save!)
      end

      it "creates a valid token" do
        expect(Security::GettyToken).to receive(:create).with(user.username, 'pwd')

        described_class.authenticate(user.username, 'pwd')
      end

      context "when the user exists" do
        it 'successfully retrieves the user' do
          authorized_user = described_class.authenticate(nil, nil)

          expect(authorized_user.username).to eq(user.username)
          expect(authorized_user.account_id).to eq(user.account_id)
        end

        it "returns an AuthorizedUser with a token" do
          authorized_user = described_class.authenticate(nil, nil)

          expect(authorized_user.token).to_not be_nil
        end

        context "and the authenticated username and database username to not match" do
          it "override the database username" do
            authorized_user = described_class.authenticate('new_user', nil)
            expect(authorized_user.username).to eq('new_user')
          end
        end
      end

      context "when the user does not exist" do
        it "raise an AuthorizationError" do
          allow(described_class::AuthorizedUser).to receive(:find_by_account_id).and_return(nil)

          expect{ described_class.authenticate(nil, nil) }.to raise_error(Esp::UnknownUserError)
        end
      end

    end

    context "with invalid credentials" do
      before(:each) do
        allow(Security::GettyToken).to receive(:create).and_return(nil)
      end

      it "returns nil" do
        unauthorized_user = described_class.authenticate('user', 'bad_password')

        expect(unauthorized_user).to be_nil
      end
    end
  end
end

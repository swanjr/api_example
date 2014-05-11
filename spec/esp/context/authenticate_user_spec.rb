require 'spec_helper'

describe Context::AuthenticateUser do

  describe '#authenticate' do
    let(:token_mock) { instance_double('Security::GettyToken') }

    context 'with valid credentials' do
      let(:user) { Role::AuthorizedUser.new(FactoryGirl.attributes_for(:user)) }

      before(:each) do
        allow(token_mock).to receive(:account_id).and_return(user.account_id)

        allow(Security::GettyToken).to receive(:create).and_return(token_mock)
        allow(Role::AuthorizedUser).to receive(:find_by).and_return(user)
      end

      it 'creates a valid token' do
        expect(Security::GettyToken).to receive(:create).with('username', 'password')

        described_class.authenticate('username', 'password')
      end

      context 'when the user exists' do
        it 'successfully retrieves the user' do
          authorized_user = described_class.authenticate(user.username, 'password')

          expect(authorized_user.username).to eq(user.username)
          expect(authorized_user.account_id).to eq(user.account_id)
          expect(authorized_user.email).to_not be_nil
        end

        it 'returns an AuthorizedUser with a token' do
          authorized_user = described_class.authenticate('new_user', 'password')

          expect(authorized_user.token).to_not be_nil
        end

        context 'and the authenticated username and database username to not match' do
          it 'override the database username' do
            expect(user).to receive(:override_username).with('new_user')
            described_class.authenticate('new_user', 'password')
          end
        end
      end

      context 'when the user does not exist' do
        it 'raise an AuthorizationError' do
          allow(Role::AuthorizedUser).to receive(:find_by).and_return(nil)

          expect{ described_class.authenticate(user.username, 'password') }.to raise_error(Esp::UnknownUserError)
        end
      end

    end

    context 'with invalid credentials' do
      before(:each) do
        allow(Security::GettyToken).to receive(:create).and_return(nil)
      end

      it 'returns nil' do
        unauthorized_user = described_class.authenticate('user', 'bad_password')

        expect(unauthorized_user).to be_nil
      end
    end
  end
end

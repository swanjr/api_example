require 'active_record_helper'

require 'models/user'

describe User do

  it "should have many roles" do
    expect(described_class.reflect_on_association(:roles).macro).to eq(:has_and_belongs_to_many)
  end

  describe "validations" do
    let(:user) { User.new(username: 'username', account_number: '100',
                     enabled: true, email: 'user@email.com') }

    it { expect(user).to validate_presence_of(:username) }
    it { expect(user).to validate_presence_of(:account_number) }
    it { expect(user).to validate_presence_of(:email) }

    it { expect(user).to validate_uniqueness_of(:username) }
    it { expect(user).to validate_uniqueness_of(:account_number) }
    it { expect(user).to validate_uniqueness_of(:email) }
  end

  describe "#find_by_account_number" do
    context "when the user is enabled" do
      before(:example) do
        User.create!(username: 'username', account_number: '100', 
                     enabled: true, email: 'user@email.com')
      end

      it "returns the enabled user" do
        user = User.for_account_number('100')
        expect(user).to_not be_nil
        expect(user.account_number).to eql('100')
      end

      it "returns nil when finding a disabled user" do
        user = User.for_account_number('100', false)
        expect(user).to be_nil
      end
    end

    context "when the user is disabled" do
      before(:example) do
        User.create!(username: 'username', account_number: '100', 
                     enabled: false, email: 'user@email.com')
      end

      it "returns the disabled user" do
        user = User.for_account_number('100', false)
        expect(user).to_not be_nil
        expect(user.account_number).to eql('100')
      end

      it "returns nil when finding an enabled user" do
        user = User.for_account_number('100', true)
        expect(user).to be_nil
      end
    end

    it "returns nil when account_number cannot be found" do
      User.create!(username: 'username', account_number: '10', email: 'user@email.com')

      user = User.for_account_number('100')
      expect(user).to be_nil
    end
  end
end

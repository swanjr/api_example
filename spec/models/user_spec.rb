require 'active_record_helper'

require 'models/user'

describe User do

  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:account_id) }

    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_uniqueness_of(:account_id) }
  end

  describe "#find_by_account_id" do
    it "returns the user with the provided account_id" do
      User.create!(:username => 'username', :account_id => '100')

      user = User.for_account_id('100')
      expect(user).to_not be_nil
      expect(user.account_id).to eql('100')
    end
  end
end

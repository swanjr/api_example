require 'spec_helper'

describe AssociatedAccount do
  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:account_id) }

    it { is_expected.to validate_uniqueness_of(:username).scoped_to(:type) }
    it { is_expected.to validate_uniqueness_of(:account_id).scoped_to(:type) }
    
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end

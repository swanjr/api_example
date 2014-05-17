require 'unit_spec_helper'

require 'models/associated_account'
require 'models/user'

describe AssociatedAccount do
  describe "validations", :db do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:account_id) }

    it { is_expected.to validate_uniqueness_of(:username).scoped_to(:type) }
    it { is_expected.to validate_uniqueness_of(:account_id).scoped_to(:type) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end

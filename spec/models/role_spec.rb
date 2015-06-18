require 'active_record_helper'

require 'models/role'

describe Role do

  it "should have many users" do
    expect(described_class.reflect_on_association(:users).macro).to eq(:has_and_belongs_to_many)
  end

  describe "validations" do
    let(:role) { Role.new(name: 'admin') }

    it { expect(role).to validate_presence_of(:name) }

    it { expect(role).to validate_uniqueness_of(:name) }
  end
end

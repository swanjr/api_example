require 'active_record_helper'

require 'models/permission'

describe Permission do

  describe "validations" do
    let(:permission) { Permission.new(name: 'create_submission_batch') }

    it { expect(permission).to validate_presence_of(:name) }
    it { expect(permission).to validate_uniqueness_of(:name) }
  end
end

require 'active_record_helper'

require 'models/contribution'

describe Contribution do

  it { is_expected.to belong_to(:owner) }
  it { is_expected.to belong_to(:file_upload) }
  it { is_expected.to belong_to(:media) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:file_upload_id) }
    it { is_expected.to validate_presence_of(:media_id) }
    it { is_expected.to validate_presence_of(:media_type) }

    it { is_expected.to validate_inclusion_of(:status).
         in_array(Contribution::statuses) }
    it { is_expected.to validate_inclusion_of(:type).
         in_array(Contribution::types) }
  end
end

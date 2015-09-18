require 'active_record_helper'

require 'models/file_info'

describe FileInfo do

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

end

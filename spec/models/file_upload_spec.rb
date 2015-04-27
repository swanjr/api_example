require 'active_record_helper'

require 'models/file_upload'

describe FileUpload do

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

end

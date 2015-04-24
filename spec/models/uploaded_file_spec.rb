require 'active_record_helper'

require 'models/uploaded_file'

describe UploadedFile do

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

end

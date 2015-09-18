require 'active_record_helper'

require 'models/file_info'
require 'models/contribution'
require 'models/video'

describe Video do
  it { is_expected.to belong_to(:preview) }
  it { is_expected.to belong_to(:thumbnail) }

end

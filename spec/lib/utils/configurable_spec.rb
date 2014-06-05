require 'unit_spec_helper'

require 'utils/configurable'

class ConfigurableDouble
  include Configurable

  # Example of access the config object
  def config
    self.class.config
  end
end

describe Configurable do
  before(:all) do
    ConfigurableDouble.configure do |config|
      config.field1 = '1'
      config.field2 = 2
    end
  end

  let(:configurable) { ConfigurableDouble.new }

  it "can be configured with any data" do
    expect(configurable.config.field1).to eq('1')
    expect(configurable.config.field2).to eq(2)
  end

  it "throws a NoMethodError if field not found" do
    expect{configurable.config.field3}.to raise_error(NoMethodError)
  end

  describe "#respond_to" do
    it "returns true for configured fields" do
      expect(configurable.config.respond_to?(:field1)).to be(true)
    end

    it "returns false for unrecognized fields" do
      expect(configurable.config.respond_to?(:field3)).to be(false)
    end
  end
end

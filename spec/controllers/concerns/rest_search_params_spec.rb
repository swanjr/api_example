require 'spec_helper'

require 'controllers/concerns/rest_search_params'

describe RestSearchParams do

  class FakeController
    include RestSearchParams

    def params
    end
  end

  let(:controller) { FakeController.new }

  describe "#fields" do
    it "returns the specified 'fields' param as an array" do
      allow(controller).to receive(:params).and_return({fields: 'name, id'})

      expect(controller.fields).to eq(['name', 'id'])
    end

    it "returns an empty array if 'fields' is not provided" do
      allow(controller).to receive(:params).and_return({})

      expect(controller.fields).to eq([])
    end
  end

  describe "#filters" do
    it "returns an array of hashes for the specified 'filters'" do
      allow(controller).to receive(:params).and_return({filters: 'id>1,name=John'})

      expect(controller.filters.size).to eq(2)
      expect(controller.filters[0]).to include(field: 'id')
      expect(controller.filters[1]).to include(field: 'name')
    end

    it "returns an empty array if 'filters' is not provided" do
      allow(controller).to receive(:params).and_return({})

      expect(controller.fields).to eq([])
    end

    it "correctly parses '=' filters" do
      allow(controller).to receive(:params).and_return({filters: ' name = John '})

      expect(controller.filters.first).to match({field: 'name', operator: '=', value: 'John'})
    end

    it "correctly parses '<=' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name<=John'})

      expect(controller.filters.first).to match({field: 'name', operator: '<=', value: 'John'})
    end

    it "correctly parses '>=' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name>=John'})

      expect(controller.filters.first).to match({field: 'name', operator: '>=', value: 'John'})
    end

    it "correctly parses '!=' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name!=John'})

      expect(controller.filters.first).to match({field: 'name', operator: '!=', value: 'John'})
    end

    it "correctly parses '<>' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name<>John'})

      expect(controller.filters.first).to match({field: 'name', operator: '<>', value: 'John'})
    end

    it "correctly parses '>' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name>John'})

      expect(controller.filters.first).to match({field: 'name', operator: '>', value: 'John'})
    end

    it "correctly parses '<' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name<John'})

      expect(controller.filters.first).to match({field: 'name', operator: '<', value: 'John'})
    end

    it "correctly parses 'in value array' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name=[ John, Joe ],id>20'})

      expect(controller.filters.first).to match({field: 'name', operator: '=', value: ['John','Joe']})
    end

    it "correctly parses 'partial match' filters" do
      allow(controller).to receive(:params).and_return({filters: 'name=*doe,name=john*,full_name=*middle*'})

      expect(controller.filters[0]).to match({field: 'name', operator: '=', value: '%doe'})
      expect(controller.filters[1]).to match({field: 'name', operator: '=', value: 'john%'})
      expect(controller.filters[2]).to match({field: 'full_name', operator: '=', value: '%middle%'})
    end
  end

  describe "#sort_order" do
    it "returns an array of parsed sort options" do
      allow(controller).to receive(:params).and_return({sort: ' name , -id '})

      expect(controller.sort_order).to contain_exactly({'name' => 'asc'}, {'id' => 'desc'})
    end

    it "returns an empty array if no sort options are provided" do
      allow(controller).to receive(:params).and_return({})

      expect(controller.sort_order).to be_empty
    end
  end

  describe "#offset" do
    it "returns the specified 'offset' param" do
      allow(controller).to receive(:params).and_return({offset: '20'})

      expect(controller.offset).to eq('20')
    end

    it "returns nil if 'offset' not provided" do
      allow(controller).to receive(:params).and_return({})

      expect(controller.offset).to be_nil
    end
  end

  describe "#limit" do
    it "returns the specified 'limit' param" do
      allow(controller).to receive(:params).and_return({limit: '100'})

      expect(controller.limit).to eq('100')
    end

    it "returns nil if 'limit' not provided" do
      allow(controller).to receive(:params).and_return({})

      expect(controller.limit).to be_nil
    end
  end
end

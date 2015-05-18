require 'active_record_helper'

require 'models/user'
require 'models/queries/invalid_field_error'
require 'models/queries/invalid_operator_error'

require 'models/queries/dynamic_search'
describe Queries::DynamicSearch do
  let(:query) { described_class.new(User) }
  let(:records) { @records }

  # Create records once for all examples since they are read only
  before(:context) do
    @records = []
    for x in 0..4
      @records << User.create!(username: "johndoe#{x}",
                               email: "jd#{x}@email.com",
                               account_number: x)
    end
  end

  # Destroy created records
  after(:context) do
    @records.each do |record|
      record.destroy!
    end
  end

  describe "#search" do
    it "returns records with a default sort of 'id asc'" do
      results = query.search

      expect(results.length).to be(5)
      expect(results.first.id < results.second.id).to be(true)
      expect(results.second.id < results.fifth.id).to be(true)
    end

    it "raises an error if an ActiveRecord class was not provided or defined by a subclass" do
      expect{described_class.new}.to raise_error(ArgumentError)
    end
  end

  describe "#filter_by" do
    it "can add multiple filters" do
      results = query.filter_by(
        { field: 'id', operator: ">", value: records.second.id },
        { field: 'id', operator: "<", value: records.last.id }
      ).search

      expect(results.length).to be(2)
      expect(results.first.id).to eql(records.third.id)
      expect(results.second.id).to eql(records.fourth.id)
    end

    it "can add an 'equality' filter" do
      filter = { field: 'id', operator: '=', value: records.first.id }
      results = query.filter_by(filter).search

      expect(results.length).to be(1)
      expect(results.first.id).to eql(records.first.id)
    end

    it "can add an 'inequality' filter" do
      filter = [
        { field: 'id', operator: '<>', value: records.first.id },
        { field: 'id', operator: '!=', value: records.last.id }
      ]
      results = query.filter_by(filter).search

      expect(results.length).to be(3)
      expect(results.first.id).to_not eql(records.first.id)
      expect(results.last.id).to_not eql(records.last.id)
    end

    it "can add a '<' filter" do
      filter = { field: 'id', operator: '<', value: records.last.id }
      results = query.filter_by(filter).search

      expect(results.length).to be(4)
      expect(results.first.id).to eql(records.first.id)
      expect(results.last.id).to eql(records.fourth.id)
    end

    it "can add a '>' filter" do
      filter = { field: 'id', operator: '>', value: records.first.id }
      results = query.filter_by(filter).search

      expect(results.length).to be(4)
      expect(results.first.id).to eql(records.second.id)
    end

    it "can add a '<=' filter" do
      filter = { field: 'id', operator: '<=', value: records.second.id }
      results = query.filter_by(filter).search

      expect(results.length).to be(2)
      expect(results.first.id).to eql(records.first.id)
      expect(results.second.id).to eql(records.second.id)
    end

    it "can add a '>=' filter" do
      filter = { field: 'id', operator: '>=', value: records.second.id }
      results = query.filter_by(filter).search

      expect(results.length).to be(4)
      expect(results.first.id).to eql(records.second.id)
    end

    it "can add a 'like' filter" do
      partial = records.first.username[0, records.first.username.length-1]
      filter = { field: 'username', operator: '=', value: "#{partial}%" }
      results = query.filter_by(filter).search

      expect(results.length).to be(5)
    end

    it "can add a 'not like' filter" do
      partial = records.first.username[1, records.first.username.length]
      filter = { field: 'username', operator: '!=', value: "%#{partial}" }
      results = query.filter_by(filter).search

      expect(results.length).to be(4)
      expect(results.first.id).to eql(records.second.id)
    end

    it "can add a 'null' filter" do
      filter = { field: 'istock_username', operator: '=', value: nil }
      results = query.filter_by(filter).search

      expect(results.length).to be(5)

      filter = { field: 'istock_username', operator: '=', value: 'null' }
      results = query.filter_by(filter).search

      expect(results.length).to be(5)
    end

    it "can add a 'not null' filter" do
      filter = { field: 'istock_username', operator: '=', value: nil }
      results = query.filter_by(filter).search

      expect(results.length).to be(5)

      filter = { field: 'istock_username', operator: '=', value: 'null' }
      results = query.filter_by(filter).search

      expect(results.length).to be(5)
    end

    it "can add a 'in values' filter" do
      filter = { field: 'id', operator: '=', value: [records.first.id, records.last.id] }
      results = query.filter_by(filter).search

      expect(results.length).to be(2)

      expect(results.first.id).to eql(records.first.id)
      expect(results.last.id).to eql(records.last.id)
    end

    it "can add a 'not in values' filter" do
      filter = { field: 'id', operator: '!=', value: [records.first.id, records.last.id] }
      results = query.filter_by(filter).search

      expect(results.length).to be(3)

      expect(results.first.id).to eql(records.second.id)
      expect(results.last.id).to eql(records.fourth.id)
    end

    it "raises an error if the field name is unknown" do
      filter = { field: 'bad_field_name', operator: '!=', value: 1 }
      expect{query.filter_by(filter).search}.to raise_error(Queries::InvalidFieldError)
    end

    it "raises an error if the operator is invalid" do
      filter = { field: 'id', operator: '~', value: 1 }
      expect{query.filter_by(filter).search}.to raise_error(Queries::InvalidOperatorError)
    end

    it "calls qualify_field on the field name" do
      expect(query).to receive(:qualify_field).with('id')

      filter = { field: 'id', operator: '=', value: 1 }
      query.filter_by(filter).search
    end

    it "skips filtering behavior if input is nil or empty" do
      results = query.filter_by(nil).search
      expect(results.length).to be(5)

      results = query.filter_by([]).search
      expect(results.length).to be(5)
    end
  end

  describe "#for_fields" do
    it "returns only the specified fields" do
      results = query.for_fields('id').search

      expect(results.first.attributes).to include('id' => records.first.id)
      expect(results.first.attributes.include?('username')).to be(false)
    end

    it "raises an error if the field name is unknown" do
      expect{query.for_fields('bad_field_name').search}.to raise_error(Queries::InvalidFieldError)
    end

    it "calls qualify_field on the field name" do
      expect(query).to receive(:qualify_field).with('id')

      query.for_fields('id').search
    end

    it "skips fields behavior if input is nil or empty" do
      results = query.for_fields(nil).search
      expect(results.length).to be(5)

      results = query.for_fields([]).search
      expect(results.length).to be(5)
    end
  end

  describe "#starting_at" do
    before do
      allow(described_class).to receive(:max_limit).and_return(4)
      allow(described_class).to receive(:default_limit).and_return(2)
    end

    it "sets the offset and limit for the search" do
      query = described_class.new(User, 3)
      results = query.starting_at(1).search

      expect(results.length).to be(3)
      results.each_with_index do |result, index|
        expect(result.id).to eql(records[index+1].id)
      end
    end

    it "set the limit equal to the max limit if the provided limit is too big" do
      query = described_class.new(User, 5)
      results = query.starting_at.search

      expect(results.length).to be(4)
    end
  end

  describe "#sort_by" do
    it "sorts a field according to the provided order" do
      results = query.sort_by('id' => 'desc').search
      expect(results.first.id).to eql(records.last.id)
    end

    it "calls qualify_field on the field name" do
      expect(query).to receive(:qualify_field).with('id')

      query.sort_by(id: 'desc').search
    end

    it "skips sorting behavior if input is nil or empty" do
      results = query.sort_by(nil).search
      expect(results.length).to be(5)

      results = query.sort_by([]).search
      expect(results.length).to be(5)
    end
  end
end

require 'spec_helper'

require 'active_model'

require 'models/validators/blank_validator'

class Person
  include ActiveModel::Validations
  attr_accessor :title

  validates :title, blank: true
end

describe BlankValidator do

  it "returns an error if validation fails" do
    person = Person.new
    person.title = 'Not blank'

    expect(person.valid?).to be(false)
    expect(person.errors).to_not be_empty
  end

  it "validates successfully if the object passes validation" do
    person = Person.new
    person.title = ' '

    expect(person.valid?).to be(true)
    expect(person.errors).to be_empty

    person.title = nil

    expect(person.valid?).to be(true)
    expect(person.errors).to be_empty
  end
end

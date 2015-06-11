require 'active_record_helper'

require 'models/contribution'

require 'controllers/api/base_error'
require 'controllers/api/bad_request_error'
require 'controllers/api/unprocessable_entity_error'
require 'controllers/api/validation_error'

require 'controllers/concerns/model_rendering'

describe ModelRendering do

  class FakeController
    include ModelRendering

    def render(hash)
    end
  end

  let(:controller) { FakeController.new }
  let(:model) { Contribution.new }

  describe "#render_model" do
    it "renders the json representation of the model" do
      expect(controller).to receive(:render).with(json: model, status: :fake_status)

      controller.render_model(model, :fake_status)
    end

    it "raises a API::ValidationError if the model contains errors" do
      errors = ActiveModel::Errors.new(model)
      errors.add(:field1, "is blank")
      allow(model).to receive(:errors).and_return(errors)

      begin
        controller.render_model(model)
        fail "did not raise an API::ValidationError"
      rescue Exception => e
        expect(e.class).to be(API::ValidationError)
        expect(e.messages[0].field).to eql(:field1)
        expect(e.messages[0].message).to eql('is blank')
      end
    end
  end

  describe "#render_models" do
    it "renders the json representation of the models with counts" do
      #Mock to_hash method on array
      model_list = [model, model]
      def model_list.to_hash
        [{field_name: 'data'}]
      end

      json_response = {
        items: model_list.to_hash,
        item_count: 2,
        offset: 1,
        total_items: 5
      }
      expect(controller).to receive(:render).with(json: json_response, status: :fake_status)

      controller.render_models(model_list, 1, 5, :fake_status)
    end
  end
end

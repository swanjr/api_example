class API::V2::Docs::Models::SearchMetadata
  include Swagger::Blocks

  swagger_schema :SearchMetadata do
    key :required, [:item_count, :total_items, :offset]
    property :item_count do
      key :type, :integer
      key :description, 'The number of items returned'
    end
    property :total_items do
      key :type, :integer
      key :description, 'The total number of items the search found'
    end
    property :offset do
      key :type, :integer
      key :description, 'The number of items not returned from the top of the search results.'
    end
  end
end

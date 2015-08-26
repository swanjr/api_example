module ModelRendering
  extend ActiveSupport::Concern

  def render_model(model, status = :ok)
    if model.errors.empty?
      render json: model, status: status
    else
      raise API::ValidationError.new.add_model_messages(model)
    end
  end

  def render_collection(items, offset, total_items = nil, status = :ok)
    # Invoke serializer to_hash method if items are models
    items = items.to_hash unless items[0].is_a?(Hash)

    json = {
      items: items,
      item_count: items.size,
      offset: offset
    }
    json[:total_items] = total_items if total_items.present?

    render json: json, status: status
  end
end

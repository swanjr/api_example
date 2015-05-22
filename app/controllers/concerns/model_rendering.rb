module ModelRendering
  extend ActiveSupport::Concern

  def render_model(model, status = :ok)
    if model.errors.empty?
      render json: model, status: status
    else
      raise API::ValidationError.new.add_model_messages(model)
    end
  end

  def render_models(model_list, offset, total_items = nil, status = :ok)
    json = {
      items: model_list.to_hash,
      item_count: model_list.size,
      offset: offset
    }
    json[:total_items] = total_items if total_items.present?

    render json: json, status: status
  end
end

module UseSsl
  extend ActiveSupport::Concern

  included do
    force_ssl if: :use_ssl?
  end

  private

  def use_ssl?
    !(Rails.env.development? ||
      Rails.env.test? ||
      Rails.application.config.controllers_without_ssl.include(params[:controller]))
  end
end

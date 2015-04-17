module UseSsl
  extend ActiveSupport::Concern

  included { force_ssl if: :use_ssl? }

  private

  def use_ssl?
    !(Rails.env.development? ||
      Rails.env.test? ||
      Rails.configuration.controllers_without_ssl.include(params[:controller]))
  end

end

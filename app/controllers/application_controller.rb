class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp, web push, badges, import maps, CSS nesting, and CSS :has
  allow_browser versions: :modern

  # Devise: permit extra fields on sign up & account update
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attrs = %i[first_name last_name street city postal_code province_id]
    devise_parameter_sanitizer.permit(:sign_up,        keys: attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: attrs)
  end
end

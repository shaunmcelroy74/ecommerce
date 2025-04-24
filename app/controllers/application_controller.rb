# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp, web push, badges, import maps, CSS nesting, and CSS :has
  allow_browser versions: :modern

  # Expose the cart helper to all views
  helper_method :current_cart

  # Devise: permit extra fields on sign up & account update
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Session-backed cart lookup/creation
  def current_cart
    @current_cart ||= begin
      cart = Cart.find_by(id: session[:cart_id]) || Cart.create!
      session[:cart_id] = cart.id
      cart
    end
  end

  protected

  # Whitelist our extra Devise fields
  def configure_permitted_parameters
    attrs = %i[first_name last_name street city postal_code province_id]
    devise_parameter_sanitizer.permit(:sign_up,        keys: attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: attrs)
  end
end

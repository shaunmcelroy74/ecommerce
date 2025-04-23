class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  def index
    @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)
    @quick_stats = {
      sales: Order.where(created_at: Time.now.midnight..Time.now).count,
      revenue: Order.where(created_at: Time.now.midnight..Time.now).sum(:total).round(),
      avg_sale: Order.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now).average(:total)&.round(2) || 0
    }
  end
end

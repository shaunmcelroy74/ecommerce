class HomeController < ApplicationController
  def index
    @main_categories = Category.take(4)
    @products = Product.limit(4)
  end
end

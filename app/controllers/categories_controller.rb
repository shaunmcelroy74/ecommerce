# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])

    # ← ensure you call .page(params[:page]) here!
    @products = @category
                  .products
                  .order(:created_at)
                  .page(params[:page])    # ← this turns it into a paginated collection
  end
end

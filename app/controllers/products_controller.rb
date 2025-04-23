class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def search
    # Retrieve the search parameters
    keyword     = params[:keyword]
    category_id = params[:category_id]

    # Start with all products
    @products = Product.all

    if keyword.present?
      downcased_keyword = "%#{keyword.downcase}%"
      @products = @products.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?",
                                  downcased_keyword, downcased_keyword)
    end

    # If a category was selected, filter the products to only those in that category.
    if category_id.present?
      @products = @products.where(category_id: category_id)
    end

    # Order the products and paginate them.
    # If you have set a default pagination per page in the Product model using Kaminari’s `paginates_per`,
    # you do not need to supply a `.per` here.
    @products = @products.order(:created_at).page(params[:page])
  end
end

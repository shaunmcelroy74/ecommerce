# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  # No authentication filter here—these are publicly accessible

  # GET /about
  def about
    @page = Page.find_by!(title: "About")
  end

  # GET /contact
  def contact
    @page = Page.find_by!(title: "Contact")
  end
end

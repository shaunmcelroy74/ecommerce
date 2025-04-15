class Admin::PagesController < AdminController
  before_action :set_page, only: %i[show edit update destroy]

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to admin_page_path(@page), notice: "Page created."
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @page.update(page_params)
      redirect_to admin_page_path(@page), notice: "Page updated."
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_path, notice: "Page deleted."
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :content)
  end
end

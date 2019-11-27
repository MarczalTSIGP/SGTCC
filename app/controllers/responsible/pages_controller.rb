class Responsible::PagesController < Responsible::BaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.pages.index'),
                 :responsible_pages_path,
                 only: [:index]

  add_breadcrumb I18n.t('breadcrumbs.pages.show'),
                 :responsible_page_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.pages.new'),
                 :new_responsible_page_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.pages.edit'),
                 :edit_responsible_page_path,
                 only: [:edit]

  add_breadcrumb I18n.t('breadcrumbs.pages.order'),
                 :responsible_pages_order_path,
                 only: [:order]

  def index
    @pages = Page.ordered.page(params[:page]).search(params[:term])
  end

  def show; end

  def new
    @page = Page.new
  end

  def edit; end

  def create
    @page = Page.new(page_params)

    if @page.save
      success_create_message
      redirect_to responsible_pages_path
    else
      error_message
      render :new
    end
  end

  def update
    if @page.update(page_params)
      success_update_message
      redirect_to responsible_page_path(@page)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @page.destroy
    success_destroy_message

    redirect_to responsible_pages_path
  end

  def update_order
    render json: Page.update_menu_order(params[:data])
  end

  def order; end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:menu_title, :fa_icon, :content, :url, :publish)
  end
end

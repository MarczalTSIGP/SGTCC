class Responsible::SiteController < Responsible::BaseController
  before_action :set_site, only: [:edit, :update]

  add_breadcrumb I18n.t('breadcrumbs.site.configs'),
                 :edit_responsible_site_path,
                 only: :edit

  def edit; end

  def update
    if @site.update(site_params)
      success_update_message
      redirect_to edit_responsible_site_path(@site)
    else
      error_message
      render :edit
    end
  end

  private

  def set_site
    @site = Site.first
  end

  def site_params
    params.require(:site).permit(:title)
  end
end

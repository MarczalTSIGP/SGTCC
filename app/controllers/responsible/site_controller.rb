class Responsible::SiteController < Responsible::BaseController
  add_breadcrumb I18n.t('breadcrumbs.site.configs'),
                 :responsible_site_configs_path,
                 only: :configs

  def configs; end
end

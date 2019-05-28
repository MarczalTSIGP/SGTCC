module BreadcrumbTitle
  extend ActiveSupport::Concern

  def homepage_title
    I18n.t('breadcrumbs.homepage')
  end
end

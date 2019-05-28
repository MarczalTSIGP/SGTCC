class Professors::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  include FlashMessage
  include BreadcrumbTitle

  add_breadcrumb I18n.t('breadcrumbs.homepage'), :professors_root_path

  layout 'layouts/professors/application'
end

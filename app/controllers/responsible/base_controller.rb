class Responsible::BaseController < ActionController::Base
  add_breadcrumb I18n.t('breadcrumbs.homepage'), :responsible_root_path

  protect_from_forgery with: :exception

  layout 'layouts/professors/application'
end

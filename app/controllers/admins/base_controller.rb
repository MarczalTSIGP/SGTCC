class Admins::BaseController < ActionController::Base
  add_breadcrumb I18n.t('breadcrumbs.homepage'), :admins_root_path

  protect_from_forgery with: :exception

  layout 'layouts/admins/application'
end

class Professors::BaseController < ActionController::Base
  add_breadcrumb I18n.t('breadcrumbs.homepage'), :professors_root_path

  protect_from_forgery with: :exception

  layout 'layouts/professors/application'
end

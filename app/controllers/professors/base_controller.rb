class Professors::BaseController < ActionController::Base
  add_breadcrumb I18n.t('breadcrumbs.homepage'), :professors_root_path

  layout 'layouts/professors/application'

  protect_from_forgery with: :exception
end

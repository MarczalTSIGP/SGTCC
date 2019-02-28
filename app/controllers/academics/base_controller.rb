class Academics::BaseController < ActionController::Base
  add_breadcrumb I18n.t('breadcrumbs.homepage'), :academics_root_path

  layout 'layouts/academics/application'

  protect_from_forgery with: :exception
end

class Academics::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  include FlashMessage

  add_breadcrumb I18n.t('breadcrumbs.homepage'), :academics_root_path

  layout 'layouts/academics/application'
end

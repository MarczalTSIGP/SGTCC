class ExternalMembers::BaseController < ActionController::Base
  protect_from_forgery with: :exception

  include FlashMessage
  include BreadcrumbTitle

  layout 'layouts/external_members/application'

  add_breadcrumb I18n.t('breadcrumbs.homepage'), :external_members_root_path
end

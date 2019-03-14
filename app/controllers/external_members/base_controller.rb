class ExternalMembers::BaseController < ActionController::Base
  add_breadcrumb I18n.t('breadcrumbs.homepage'), :external_members_root_path

  layout 'layouts/external_members/application'

  protect_from_forgery with: :exception
end

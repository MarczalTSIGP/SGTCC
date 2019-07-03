require 'active_support/concern'

module Confirmable
  extend ActiveSupport::Concern

  included do
    def confirm(class_name, login, params)
      class_name.find_by("#{login}": params[:login])&.valid_password?(params[:password])
    end
  end
end

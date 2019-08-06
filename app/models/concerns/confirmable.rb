require 'active_support/concern'

module Confirmable
  extend ActiveSupport::Concern

  included do
    def confirm(current_user, login, params)
      login == params[:login] && current_user.valid_password?(params[:password])
    end
  end
end

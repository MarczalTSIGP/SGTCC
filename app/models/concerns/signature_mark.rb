require 'active_support/concern'

module SignatureMark
  extend ActiveSupport::Concern

  included do
    def mark
      signatures.where(status: true).map do |signature|
        add_signature(signature.updated_at, signature.user_type, signature.user)
      end
    end

    private

    def add_signature(datetime, user_type, user)
      { name: user.name, role: I18n.t("signatures.users.roles.#{user.gender}.#{user_type}"),
        date: I18n.l(datetime, format: :short), time: I18n.l(datetime, format: :time) }
    end
  end
end

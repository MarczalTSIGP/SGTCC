require 'active_support/concern'

module SignatureMark
  extend ActiveSupport::Concern

  module ClassMethods
    private

    def add_signature(datetime, user_type, user)
      { name: user.name, role: I18n.t("signatures.users.roles.#{user.gender}.#{user_type}"),
        date: I18n.l(datetime, format: :short), time: I18n.l(datetime, format: :time) }
    end
  end

  included do
    def self.mark(orientation_id, document_type_id)
      signatures = by_condition_and_document_t({ orientation_id: orientation_id,
                                                 status: true }, document_type_id)
      signatures.map do |signature|
        add_signature(signature.updated_at, signature.user_type, signature.user)
      end
    end
  end
end

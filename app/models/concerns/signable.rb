require 'active_support/concern'

module Signable
  extend ActiveSupport::Concern

  included do
    def signed_signatures
      signatures.where(status: true)
    end

    def signatures_mark
      signed_signatures.map do |signature|
        class_name = signature.user_type.camelcase.constantize
        name = class_name.send('find', signature.user_id)&.name
        add_signature(name, signature.updated_at)
      end
    end

    private

    def add_signature(name, datetime)
      { name: name, date: I18n.l(datetime, format: :short), time: I18n.l(datetime, format: :time) }
    end
  end
end

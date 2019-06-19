require 'active_support/concern'

module Signable
  extend ActiveSupport::Concern

  included do
    def signed_signatures
      signatures.where(status: true)
    end

    def signatures_mark
      signed_signatures.map do |signature|
        user = select_user(signature)
        add_signature(user.name, signature.updated_at)
      end
    end

    private

    def add_signature(name, datetime)
      { name: name, date: I18n.l(datetime, format: :short), time: I18n.l(datetime, format: :time) }
    end

    def select_user(signature)
      user_id = signature.user_id
      return signature.orientation.academic if signature.user_type == 'academic'
      return select_professor(signature) if signature.user_type == 'professor'
      signature.orientation.external_member_supervisors.find_by(id: user_id)
    end

    def select_professor(signature)
      advisor = signature.orientation.advisor
      return advisor if advisor.id == signature.user_id
      signature.orientation.professor_supervisors.find_by(id: signature.user_id)
    end
  end
end

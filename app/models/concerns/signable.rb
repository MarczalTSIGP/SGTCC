require 'active_support/concern'

module Signable
  extend ActiveSupport::Concern

  included do
    def signatures_mark
      signed_signatures.map do |signature|
        user = select_user(signature)
        add_signature(user.name, signature.updated_at, user.gender, signature.user_type)
      end
    end

    private

    def add_signature(name, datetime, user_gender, user_type)
      { name: name, role: I18n.t("signatures.users.roles.#{user_gender}.#{user_type}"),
        date: I18n.l(datetime, format: :short), time: I18n.l(datetime, format: :time) }
    end

    def select_user(signature)
      return signature.orientation.academic if signature.user_type == 'academic'
      return select_professor(signature) if professor_user?(signature.user_type)
      signature.orientation.external_member_supervisors.find_by(id: signature.user_id)
    end

    def professor_user?(user_type)
      user_type.include?('professor_supervisor') || user_type.include?('advisor')
    end

    def select_professor(signature)
      advisor = signature.orientation.advisor
      return advisor if advisor.id == signature.user_id
      signature.orientation.professor_supervisors.find_by(id: signature.user_id)
    end
  end
end

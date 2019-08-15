require 'active_support/concern'

module DocumentSigned
  extend ActiveSupport::Concern

  included do
    def academic_signed?(academic)
      signature_by_user(academic.id, :academic).status
    end

    def professor_signed?(professor)
      signature_by_user(professor.id, professor.user_types).status
    end
  end
end

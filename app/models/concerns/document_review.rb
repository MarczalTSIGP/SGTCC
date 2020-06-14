require 'active_support/concern'

module DocumentReview
  extend ActiveSupport::Concern

  included do
    def signed_by_user?(user_type)
      return if all_signed?

      signatures.where(user_type: user_type, status: true).size == user_type.size
    end

    def tdo_for_review?
      signed_by_user?(%w[advisor])
    end

    def tep_for_review?
      signed_by_user?(%w[academic])
    end

    def tso_for_review?
      signed_by_user?(%w[academic])
    end
  end
end

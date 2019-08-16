require 'active_support/concern'

module DocumentReview
  extend ActiveSupport::Concern

  included do
    def signed_by_users?(user_types)
      return if all_signed?
      signatures.where(user_type: user_types, status: true).size == user_types.size
    end

    def tdo_for_review?
      signed_by_users?(%w[advisor])
    end

    def tep_for_review?
      signed_by_users?(%w[advisor academic coordinator])
    end

    def tso_for_review?
      signed_by_users?(%w[advisor new_advisor academic])
    end
  end
end

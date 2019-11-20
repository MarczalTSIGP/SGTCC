require 'active_support/concern'

module UsersToDocument
  extend ActiveSupport::Concern

  included do
    def users_to_document(users)
      users.map do |user|
        { id: user.id, name: user.name_with_scholarity }
      end
    end

    def evaluators_object
      { professors: users_to_document(professors),
        external_members: users_to_document(external_members) }
    end
  end
end

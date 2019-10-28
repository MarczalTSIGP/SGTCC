require 'active_support/concern'

module UsersToDocument
  extend ActiveSupport::Concern

  included do
    def users_to_document(users)
      users.map do |user|
        { id: user.id, name: user.name_with_scholarity }
      end
    end
  end
end

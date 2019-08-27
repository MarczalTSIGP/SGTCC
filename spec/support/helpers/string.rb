module Helpers
  module String
    def scholarity_with_name(user)
      "#{user.scholarity.abbr} #{user.name}"
    end
  end
end

require 'active_support/concern'

module KaminariHelper
  extend ActiveSupport::Concern

  included do
    def self.paginate_array(data, page)
      Kaminari.paginate_array(data).page(page)
    end
  end
end

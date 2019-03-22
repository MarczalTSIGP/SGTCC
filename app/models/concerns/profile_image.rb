require 'active_support/concern'

module ProfileImage
  extend ActiveSupport::Concern

  included do
    mount_uploader :profile_image, ProfileImageUploader
  end
end

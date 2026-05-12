require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  # Keep CarrierWave temporary cache out of the persisted uploads volume.
  # In production the final files are still stored under `public/uploads`,
  # but the transient cache must live in a writable runtime directory.
  config.cache_dir = Rails.root.join('tmp/carrierwave')
end

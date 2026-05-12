require 'rails_helper'

RSpec.describe 'CarrierWave configuration' do
  it 'stores the temporary cache in the app tmp directory' do
    expect(PdfUploader.new.cache_dir).to eq(Rails.root.join('tmp', 'carrierwave').to_s)
  end
end

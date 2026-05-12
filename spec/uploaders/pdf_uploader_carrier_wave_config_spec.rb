require 'rails_helper'

describe PdfUploader do
  it 'stores the temporary cache in the app tmp directory' do
    expect(described_class.new.cache_dir).to eq(Rails.root.join('tmp/carrierwave'))
  end
end

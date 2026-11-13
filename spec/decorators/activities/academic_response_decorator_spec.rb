require 'rails_helper'

RSpec.describe Activities::AcademicResponseDecorator do
  subject(:response) { described_class.new(academic, true, orientation) }

  let(:orientation) { create(:orientation) }
  let(:academic) { orientation.academic }

  it 'delegates academic attributes' do
    expect(response.name).to eq(academic.name)
    expect(response.id).to eq(academic.id)
  end

  it 'adds the sent flag and the orientation' do
    expect(response.sent?).to be(true)
    expect(response.orientation).to eq(orientation)
  end

  # A versão com `method_missing` respondia `name`, mas `respond_to?(:name)` devolvia
  # false, porque `respond_to_missing?` só chamava `super`.
  it 'reports the delegated methods through respond_to?' do
    expect(response).to respond_to(:name, :email, :sent?, :orientation)
  end
end

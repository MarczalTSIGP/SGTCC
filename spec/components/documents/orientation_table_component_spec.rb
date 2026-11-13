require 'rails_helper'

RSpec.describe Documents::OrientationTableComponent, type: :component do
  include ViewComponent::TestHelpers

  let(:documents) { Document.none.page(1) }

  def render_component(**)
    render_inline(
      described_class.new(
        documents:,
        row_partial: 'academics/documents/document_orientation',
        **
      )
    )
  end

  it 'renders the common columns, empty state, and pagination container', :aggregate_failures do
    render_component

    expect(page).to have_text(Document.human_attribute_name('orientation'))
    expect(page).to have_text(Document.human_attribute_name('academic'))
    expect(page).to have_text(Document.human_attribute_name('document_type'))
    expect(page).to have_text(Document.human_attribute_name('created_at'))
    expect(page).to have_text(I18n.t('helpers.no_results'))
  end

  it 'renders the optional signature and action columns' do
    render_component(show_all_signed: true, actions_colspan: 3)

    expect(page).to have_text(Document.human_attribute_name('all_signed'))
    expect(page).to have_css('th[colspan="3"]')
  end

  it 'omits optional columns by default' do
    render_component

    expect(page).to have_no_text(Document.human_attribute_name('all_signed'))
    expect(page).to have_no_css('th[colspan]')
  end
end

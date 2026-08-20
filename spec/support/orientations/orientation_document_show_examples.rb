module OrientationDocumentShowExamples
  def expect_orientation_document_contents
    expect(page).to have_contents(orientation_document_contents)
    expect_orientation_document_supervisors
  end

  def orientation_document_contents
    [*orientation_document_basic_contents,
     document_date(document.created_at)]
  end

  def orientation_document_basic_contents
    [*orientation_document_orientation_contents,
     orientation.institution.trade_name,
     orientation.institution.external_member.name,
     scholarity_with_name(orientation.advisor)]
  end

  def orientation_document_orientation_contents
    [orientation.title,
     orientation.academic.name,
     orientation.academic.ra]
  end

  def expect_orientation_document_supervisors
    orientation.supervisors.each do |supervisor|
      expect(page).to have_text(scholarity_with_name(supervisor))
    end
  end

  def expect_orientation_document_active_link
    expect(page).to have_css("a[href='#{active_link}'].active")
  end
end

RSpec.configure do |config|
  config.include OrientationDocumentShowExamples
end

RSpec.shared_examples 'orientation document show page' do
  it 'shows the document' do
    expect_orientation_document_contents
    expect_orientation_document_active_link
  end
end

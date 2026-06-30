module DocumentShowExamples
  def expect_document_contents(created_at:, extra_contents: [])
    expect(page).to have_contents(document_contents(created_at, extra_contents))
    expect_document_supervisors
  end

  def document_contents(created_at, extra_contents)
    [orientation.title,
     *academic_contents,
     *institution_contents,
     scholarity_with_name(orientation.advisor),
     *extra_contents,
     document_date(created_at)]
  end

  def academic_contents
    [orientation.academic.name, orientation.academic.ra]
  end

  def institution_contents
    [orientation.institution.trade_name,
     orientation.institution.external_member.name]
  end

  def expect_document_supervisors
    orientation.supervisors do |supervisor|
      expect(page).to have_text(scholarity_with_name(supervisor))
    end
  end

  def expect_document_signature_marks
    document.mark.each do |signature|
      expect(page).to have_text(
        signature_register(signature[:name], signature[:role],
                           signature[:date], signature[:time])
      )
    end
  end
end

RSpec.configure do |config|
  config.include DocumentShowExamples
end

RSpec.shared_examples 'a pending document show page' do |document_name|
  it "shows the document of #{document_name}" do
    visit document_path

    expect_document_contents(created_at: pending_document_created_at)
    expect(page).to have_css("a[href='#{pending_documents_path}'].active")
  end
end

RSpec.shared_examples 'a signed document show page' do |document_name|
  it "shows the document of #{document_name}" do
    document.signatures.each(&:sign)
    visit document_path

    expect_document_contents(
      created_at: signed_document_created_at,
      extra_contents: [*signed_document_extra_contents,
                       signature_code_message(document)]
    )
    expect_document_signature_marks
    expect(page).to have_css("a[href='#{signed_documents_path}'].active")
  end
end

RSpec.shared_examples 'an unauthorized document show access' do |description|
  it description do
    visit unauthorized_document_path

    expect(page).to have_current_path pending_documents_path
    expect(page).to have_flash(:warning, text: not_authorized_message)
  end
end

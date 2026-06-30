RSpec.shared_examples 'responsible search with no results' do |term|
  context 'when the result is not found' do
    it 'returns not found message' do
      fill_in 'term', with: term
      first('#search').click

      expect(page).to have_message(no_results_message, in: 'table tbody')
    end
  end
end

RSpec.shared_examples 'responsible destroy success flow' do |message_key:,
                                                              description: 'show success message'|
  it description do
    click_on_destroy_link(destroy_path)
    accept_alert

    expect(page).to have_flash(:success, text: message(message_key))
    expect(page).to have_no_text(destroyed_record_name)
  end
end

RSpec.shared_examples 'responsible form blank errors' do |selectors|
  it 'show errors' do
    submit_form('input[name="commit"]')

    expect(page).to have_flash(:danger, text: errors_message)

    selectors.each do |selector, error_message|
      message = error_message.nil? ? blank_error_message : public_send(error_message)
      expect(page).to have_message(message, in: selector)
    end
  end
end

RSpec.shared_examples 'responsible update blank errors' do |fields:,
                                                             selectors:,
                                                             description: 'show errors'|
  it description do
    fields.each { |field| fill_in field, with: '' }
    submit_form('input[name="commit"]')

    expect(page).to have_flash(:danger, text: errors_message)

    selectors.each do |selector, error_message|
      message = error_message.nil? ? blank_error_message : public_send(error_message)
      expect(page).to have_message(message, in: selector)
    end
  end
end

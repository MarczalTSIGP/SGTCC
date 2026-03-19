# Preview all emails at http://localhost:3000/rails/mailers
class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(preview_external_member, 'faketoken')
  end

  def password_change
    Devise::Mailer.password_change(preview_external_member)
  end

  def email_changed
    Devise::Mailer.email_changed(preview_external_member)
  end

  private

  def preview_external_member
    ExternalMember.find_or_create_by!(email: 'preview.external_member@example.com') do |record|
      record.name = 'External Member Preview'
      record.personal_page = 'https://example.com/external-member-preview'
      record.gender = :male
      record.working_area = 'Sistemas de Informacao'
      record.is_active = true
      record.password = 'password123'
      record.password_confirmation = 'password123'
      record.scholarity = Scholarity.first || Scholarity.create!(name: 'Preview', abbr: 'PRV')
    end
  end
end

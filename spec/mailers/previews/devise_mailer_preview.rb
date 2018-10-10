class DeviseMailerPreview < ActionMailer::Preview
    # Preview all emails at http://localhost:3000/rails/mailers
    def reset_password_instructions
        Devise::Mailer.reset_password_instructions(User.first, 'faketoken')
    end

    def password_change
        Devise::Mailer.password_change(User.first)
    end

    def email_changed
        Devise::Mailer.email_changed(User.first)
    end
end

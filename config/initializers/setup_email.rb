ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mailtrap.io",
  :port                 => 2525,
  :domain               => "smtp.mailtrap.io",
  :user_name            => ENV['MAILTRAP_USERNAME'],
  :password             => ENV['MAILTRAP_PASSWORD'],
  :authentication       => :cram_md5
}

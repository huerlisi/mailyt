SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    # Mailyt navigation
    primary.item :emails, "Mail Journal", emails_path, :highlights_on => /\/emails(\/search.*)?$/
    primary.item :new_email, "Compose Mail", new_email_path, :highlights_on => /\/emails\/new/
    primary.item :logout, "Logout", destroy_user_session_path, :highlights_on => /\/users\/sign_out/, :if => Proc.new { user_signed_in? }
    primary.item :logout, "Login", new_user_session_path, :highlights_on => /\/users\/sign_in/, :unless => Proc.new { user_signed_in? }
  end
end

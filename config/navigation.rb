SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    # Mailyt navigation
    primary.item :emails, "Mail Journal", emails_path, :highlights_on => /\/emails(\/search.*)?$/
    primary.item :new_email, "Compose Mail", new_email_path, :highlights_on => /\/emails\/new/
  end
end

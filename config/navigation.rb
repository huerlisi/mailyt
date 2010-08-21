SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    # CyMail navigation
    primary.item :emails, "Mails", emails_path, :highlights_on => /\/emails/
  end
end

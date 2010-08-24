Given /^the following emails:$/ do |emails|
  Email.create!(emails.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) email$/ do |pos|
  visit emails_path
  within("ul.list li:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following emails:$/ do |expected_emails_table|
  emails = expected_emails_table.hashes
  for email in emails
    Then "I should see \"#{email[:subject]}\""
  end
end

When /^I click on the ascending (.+) sort link$/ do |column|
  click_link "Ascending #{column}"
end

When /^I click on the (.+) header down link/ do |column|
  click_link "Descending #{column}"
end

When /^I search for "([^"]*)"$/ do |value|
  When "I fill in \"#{value}\" for \"Search\""
  When "I press \"Search\""
end
  
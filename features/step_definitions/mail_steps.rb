Given /^the following mails:$/ do |mails|
  Mail.create!(mails.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) mail$/ do |pos|
  visit mails_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following mails:$/ do |expected_mails_table|
  expected_mails_table.diff!(tableish('table tr', 'td,th'))
end

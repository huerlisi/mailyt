Feature: Inbox filtering
  In order to not get lost in a flood of mails
  an average user
  wants to filter the mails in the inbox.

  Scenario: Filter the inbox by subject
    Given the following emails:   
      |to|name|date|subject|body|
      |to 1|name 1|2001-01-01|subject 1|body 1|
      |to 2|name 2|2001-01-02|subject 2|body 2|
      |to 3|name 3|2001-01-03|subject 3|body 3|
      |to 4|name 4|2001-01-04|subject 4|body 4|
    When I am on the emails page
      And I search for "subject 4"
    Then I should see the following emails:
      |To|Date|Subject|
      |name 4 <to 4>|2001-01-04|subject 4|

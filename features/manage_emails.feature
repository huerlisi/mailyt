Feature: Manage emails
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Scenario: Register new email
    Given I am on the new email page
    And I fill in "To" with "to 1"
    And I fill in "Name" with "name 1"
    And I fill in "Subject" with "subject 1"
    And I fill in "Body" with "body 1"
    And I press "Create Mail"
    Then I should be on the emails page
    And I should see "to 1"
    And I should see "name 1"
    And I should see "subject 1"

  Scenario: Delete email
    Given the following emails:   
      |to|name|date|subject|body|
      |to 1|name 1|2001-01-01|subject 1|body 1|
      |to 2|name 2|2001-01-02|subject 2|body 2|
      |to 3|name 3|2001-01-03|subject 3|body 3|
      |to 4|name 4|2001-01-04|subject 4|body 4|
    When I delete the 3rd email
    Then I should see the following emails:
      |To|Date|Subject|
      |name 1 <to 1>|2001-01-01|subject 1|
      |name 2 <to 2>|2001-01-02|subject 2|
      |name 4 <to 4>|2001-01-04|subject 4|

  Scenario: Sort inbox
    Given the following emails:
      |to|name|date|subject|body|
      |to 1|name 1|2001-01-01|subject 1|body 1|
      |to 2|name 2|2001-01-02|subject 2|body 2|
      |to 3|name 3|2001-01-03|subject 3|body 3|
      |to 4|name 4|2001-01-04|subject 4|body 4|
    When I am on the emails page
    And I click on the date header
    Then I should see the following emails:
      |To|Date|Subject|
      |name 4 <to 4>|2001-01-04|subject 4|
      |name 3 <to 3>|2001-01-03|subject 3|
      |name 2 <to 2>|2001-01-02|subject 2|
      |name 1 <to 1>|2001-01-01|subject 1|
    
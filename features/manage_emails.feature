Feature: Manage emails
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Scenario: Register new email
    Given I am on the new email page
    And I fill in "Name" with "name 1"
    And I fill in "Subject" with "subject 1"
    And I fill in "Body" with "body 1"
    And I press "Create Mail"   
    Then I should see "Emails" 
#    And I should see "name 1"
#    And I should see "subject 1"
#    And I should see "body 1"

  # Rails generates Delete links that use Javascript to pop up a confirmation
  # dialog and then do a HTTP POST request (emulated DELETE request).
  #
  # Capybara must use Culerity/Celerity or Selenium2 (webdriver) when pages rely  
  # on Javascript events. Only Culerity/Celerity supports clicking on confirmation
  # dialogs.
  #
  # Since Culerity/Celerity and Selenium2 has some overhead, Cucumber-Rails will
  # detect the presence of Javascript behind Delete links and issue a DELETE request
  # instead of a GET request.
  #
  # You can turn this emulation off by tagging your scenario with @no-js-emulation.
  # Turning on browser testing with @selenium, @culerity, @celerity or @javascript
  # will also turn off the emulation. (See the Capybara documentation for 
  # details about those tags). If any of the browser tags are present, Cucumber-Rails
  # will also turn off transactions and clean the database with DatabaseCleaner
  # after the scenario has finished. This is to prevent data from leaking into
  # the next scenario.
  #
  # Another way to avoid Cucumber-Rails' javascript emulation without using any
  # of the tags above is to modify your views to use <button> instead. You can
  # see how in http://github.com/jnicklas/capybara/issues#issue/12
  #
  Scenario: Delete email
    Given the following emails:   
      |to|name|date|subject|body|
      |to 1|name 1|2001-01-01|subject 1|body 1|
      |to 2|name 2|2001-01-02|subject 2|body 2|
      |to 3|name 3|2001-01-03|subject 3|body 3|
      |to 4|name 4|2001-01-04|subject 4|body 4|
    When I delete the 3rd email
    Then I should see the following emails:
      |To|Name|Date|Subject|
      |to 1|name 1|2001-01-01|subject 1|
      |to 2|name 2|2001-01-02|subject 2|
      |to 4|name 4|2001-01-04|subject 4|

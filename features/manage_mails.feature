Feature: Manage mails
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Scenario: Register new mail
    Given I am on the new mail page
    And I fill in "Date" with "2010-01-20"  
    And I fill in "Subject" with "subject 1"
    And I fill in "Body" with "body 1"
    And I press "Create mail"   
    Then I should see "to 1" 
    And I should see "name 1"
    And I should see "2010-01-20"
    And I should see "subject 1"
    And I should see "body 1"

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
  Scenario: Delete mail
    Given the following mails:   
      |to|name|date|subject|body|
      |to 1|name 1|date 1|subject 1|body 1|
      |to 2|name 2|date 2|subject 2|body 2|
      |to 3|name 3|date 3|subject 3|body 3|
      |to 4|name 4|date 4|subject 4|body 4|
    When I delete the 3rd mail
    Then I should see the following mails:
      |To|Name|Date|Subject|Body|
      |to 1|name 1|date 1|subject 1|body 1|
      |to 2|name 2|date 2|subject 2|body 2|
      |to 4|name 4|date 4|subject 4|body 4|

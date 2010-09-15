// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Speed up visual changes for some AJAX calls
document.observe("dom:loaded", function() {
  links = $$(".mark-read a");
  links.each(function(link) {
    link.observe("ajax:before", function(event) {
      element = event.findElement('li.email');
      element.toggleClassName('seen');
      element.toggleClassName('unseen');
    });
  });

  links = $$(".destroy a");
  links.each(function(link) {
    link.observe("ajax:before", function(event) {
      element = event.findElement('li.email');
      element.hide();
    });
  });
});

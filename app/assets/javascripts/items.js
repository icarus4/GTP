// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $("tr[data-link]").click(function(e) {
    e.preventDefault();
    window.location = $(this).data("link");
  });
})

$(function() {
  $(".pins").on("click", "a", function(e) {
    if ($(this).hasClass("disabled")) {
      e.preventDefault();
      return false;
    }
  });
});

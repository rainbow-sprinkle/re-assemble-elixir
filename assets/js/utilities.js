$(function(){

  // TODO: This seems to not remotely work. And I'm unsure how to make it work
  // in a LiveView-heavy world.

  $('[data-toggle="tooltip"]').tooltip({delay: 100});

  $(".js-chosen-select").chosen();

  $("[data-focus-on-click]").click(function(){
    var target_selector = $(this).data("focus-on-click");
    $(target_selector).focus();
  });

  $(".js-copy-input").click(function(e){
    e.preventDefault()
    var fromSel = $(this).data("from")
    var toSel = $(this).data("to")
    var valueToCopy = $(fromSel).val()
    $(toSel).val(valueToCopy)
  })

  // Apply this class to an input or an entire form to suppress submit on enter.
  // (HTML-only method: https://stackoverflow.com/a/51507806/1729692)
  $('.js-suppress-enter').keydown(function(e){
    if (e.keyCode == 13) {
      console.log("ENTER press detected, default handler suppressed.")
      e.preventDefault()
    }
  })
});

$(function (){
  $("#pastable-source").hide();
  $("#paste-source").click (function (event) {
    event.preventDefault();
    $("#pastable-source").toggle();
  })
});

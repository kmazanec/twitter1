$(document).ready(function() {

  // if ( $('#waiting').size() !== 0 ) {
  //   var name = $('#screen_name').text();
  //   var url = "/ajax/" + name;
  //   $.get(url, function(response){
  //     $('.container').empty();
  //     $('.container').append(response);
  //   });
  // }

  $("#post_new_tweet").on("submit", function(event){
    event.preventDefault();
    $("#response_message").empty();
    var data = $(this).serialize();
    var url = $(this).attr('action');

    console.log(this);
    $(this).attr("disabled", true);
    console.log(this);

    $("#waiting").show();

    $.post(url, data, function(response){
      $("#post_new_tweet").attr("disabled", false);
      console.log($('#post_new_tweet'));
      $("#response_message").text(response);
      $("#waiting").hide();
    });

  });

});
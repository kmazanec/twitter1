$(document).ready(function() {

  if ( $('#pacman').size() !== 0 ) {
    var name = $('#screen_name').text();
    var url = "/ajax/" + name;
    $.get(url, function(response){
      $('.container').empty();
      $('.container').append(response);
    });
  }

});

$(document).ready(function() {
  $('form').on('submit', function(event){
    event.preventDefault();
    var inputs = $('form').serialize();
    // $.post('/', inputs, function(data) {
    //   $('.tweet_list').append(data);
    // });
    $.ajax({
      url: '/',
      type: 'POST',
      data: inputs,
      success: function(data){
        $('.tweet_list').html(data).hide();
        $('.tweet_list').show('fold',{},2000);
      },
      beforeSend: function(){
        $('.tweet_list').html('<div class="circle_loader"><div>Reticulating Splines...</div><div class="circle"></div><div class="circle1"></div></div>');
      },
    });

  })
});

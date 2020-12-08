(function() {
  $('.feedback-form').on("submit", function() {
    $('.error-message').remove();
    var msg = $('#message');
    if(msg.val() === '') {
      msg.before("<p class='error-message'>can't be blank</p>");
      return false;
    }
    var form = $(this);
    var data = form.serialize();
    $.ajax({
      type: "POST",
      url: $(this).attr('action'),
      data: data
    }).done(function(json){
      form[0].reset();
      var message = '<h1 class="govuk-heading-l thanks">Thank you for your feedback</h1>';

      $(message).hide().prependTo(form).fadeIn(1000);

      setTimeout(function(){
        $(".govuk-heading-l.thanks").fadeOut("slow");
      }, 10000);
    }).fail(function(json){
      var message = '<h1 class="govuk-heading-m error-message">Something went wrong, please check data you entered.</h1>';

      $(message).hide().appendTo(form).fadeIn();
    });
    return false;
  });
})();

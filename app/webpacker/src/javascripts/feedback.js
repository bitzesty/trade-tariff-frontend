(function() {
  $('.feedback-form').submit(function() {
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
      }).success(function(json){
          form[0].reset();
          $('<h1 class="govuk-heading-l thanks">Thanks you for your feedback</h1>')
              .hide().prependTo(form).fadeIn(1000);
          setTimeout(function(){
              $(".govuk-heading-l.thanks").fadeOut("slow");
          }, 10000)
      });
      return false;
  });
})();

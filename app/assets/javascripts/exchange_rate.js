$(document).ready(function() {

  if ($("[data-sticky-element]").length === 0) {
    return;
  }

  $("[data-sticky-element]").each(function() {
    var el = $(this);

    GOVUK.stopScrollingAtFooter.addEl($(el), $(el).height());
  });

  $("[data-sticky-element]").click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    $("html,body").animate({
      scrollTop: $(".contents-list h2").offset().top - 50
    }, 500);
  })

  $(window).scroll(function() {
    var target = $(".contents-list h2");

    if (target[0].getBoundingClientRect().top < 0) {
      $("[data-sticky-element]").removeClass("sticky--hidden");
    } else {
      $("[data-sticky-element]").addClass("sticky--hidden");
    }
  })
});

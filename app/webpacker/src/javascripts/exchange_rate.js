$(document).ready(function() {

  if ($("[data-sticky-element]").length === 0) {
    return;
  }

  $("[data-sticky-element]").each(function() {
    var el = $(this);

    GOVUK.stopScrollingAtFooter.addEl($(el), $(el).height());
  });

  $("[data-sticky-element]").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();

    $("html,body").animate({
      scrollTop: $(".contents-list h3").offset().top - 50
    }, 500);
  });

  $(window).on("scroll", function() {
    var target = $(".contents-list h3");

    if (target[0].getBoundingClientRect().top < 0) {
      $("[data-sticky-element]").removeClass("sticky--hidden");
    } else {
      $("[data-sticky-element]").addClass("sticky--hidden");
    }
  })
});

var $fullscreen = $(".fullscreen");
if ($fullscreen.length > 0) {
  var $navbar = $('.navbar');
  var resize = function () {
    var height = $(window).height() - $navbar.height();
    $fullscreen.height(height);
  };
  resize();
  $(window).resize(resize);
}
$('.tiny-button').disableSelection();
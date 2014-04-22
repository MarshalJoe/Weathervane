$(function () {

	$(window).scroll(function (e) {
		var y = $(this).scrollTop();

		if (y > 900) {
			$(".second-photo p").fadeIn("slow");
		} else {
			$(".second-photo p").fadeOut("slow");
		}



	});


});
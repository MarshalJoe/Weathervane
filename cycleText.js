$(function() {


	var words = ["rain", "snow", "sleet", "traffic", "zombies", "it all"];


	function fadeTextInOut (element, word, time) {
		setTimeout((function () {
			$(element).text(word).fadeIn("slow", function () {
				$(element).fadeOut("slow");
			});
		}), time)
	}


	function cycleText (element, array) {
		var timeStep = 0;
		for (var i = 0; i < array.length; i++) {
			timeStep += 1500;
			fadeTextInOut(element, array[i], timeStep);

			// if (i) {

			// }

		}
	}

	cycleText("#word", words);


});
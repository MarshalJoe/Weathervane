$(function() {


	var words = ["rain", "snow", "sleet", "traffic", "zombies", "it all"];


	function fadeTextInOut (element, word, time) {
		setTimeout((function () {
			$(element).text(word).fadeIn("fast", function () {
				$(element).fadeOut(750);
			});
		}), time)
	}

	function fadeTextIn (element, word, time) {
		setTimeout((function () {
			$(element).text(word).fadeIn("fast");
		}), time)
	}

	function cycleText (element, array) {
		var timeStep = 0;
		for (var i = 0; i < array.length; i++) {
			timeStep += 1250;

			if (i < (array.length - 1)) {
				fadeTextInOut(element, array[i], timeStep);
			} else {
				fadeTextIn(element, array[i], timeStep)
			}

		}
	}

	cycleText("#word", words);


});
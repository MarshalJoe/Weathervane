$(function() {


	var words = ["rain", "snow", "sleet", "traffic", "zombies", "it all"];


	function fadeTextInOut (element, word, time) {
		setTimeout((function () {
			$(element).text(word).fadeIn("slow", function () {
				$(element).fadeOut("slow");
			});
		}), time)
	}

	function fadeTextIn (element, word, time) {
		setTimeout((function () {
			$(element).text(word).fadeIn("slow");
		}), time)
	}

	function cycleText (element, array) {
		var timeStep = 0;
		for (var i = 0; i < array.length; i++) {
			timeStep += 1500;

			if (i < (array.length - 1)) {
				fadeTextInOut(element, array[i], timeStep);
			} else {
				fadeTextIn(element, array[i], timeStep)
			}

		}
	}

	cycleText("#word", words);


});
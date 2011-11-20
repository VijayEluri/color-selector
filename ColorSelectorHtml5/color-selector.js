var COLOR_MIN = 0;
var COLOR_MAX = 255;

var RED = "red";
var GREEN = "green";
var BLUE = "blue";
var ALPHA = "alpha";

function $(id) {
	return document.getElementById(id);
}

var synchronizedControls = [];

var redControl, greenControl, blueControl, alphaControl;

var webColorFilter;

/**
 * Função que realiza a troca de cores do canvas.
 */
var changeColor;

function init() {

	function initColorControls() {
		var foreFunction = function(value) {
			return (value > (COLOR_MAX / 2)) ? "black" : "white";
		};

		redControl = new ColorControl(RED, foreFunction, function(value) {
			return "rgb(" + value + ", 0, 0)";
		});
		greenControl = new ColorControl(GREEN, foreFunction, function(value) {
			return "rgb(0, " + value + ", 0)";
		});
		blueControl = new ColorControl(BLUE, function(value) {
			return "white";
		}, function(value) {
			return "rgb(0, 0, " + value + ")";
		});

		alphaControl = new AlphaControl(ALPHA);
	}

	function initCanvas() {
		var canvas = $("canvas");
		changeColor = canvas.filters ? function(r, g, b, a) { // IE
			canvas.style.backgroundColor = "rgb(" + r + ", " + g + ", " + b
					+ ")";
			canvas.style.filter = "alpha(opacity=" + (100 * a) + ")";
		} : function(r, g, b, a) { // W3C
			canvas.style.backgroundColor = "rgba(" + r + ", " + g + ", " + b
					+ ", " + a + ")";
		};
	}

	function initFormatter() {
		// Initialize Color Format Combo
		var selectFormat = $("formatType");
		for ( var i = 0; i < formatters.length; i++) {
			selectFormat.options[i] = new Option(formatters[i].name);
		}
	}

	function initColors() {
		redControl.setValue(redControl.getValue());
		greenControl.setValue(greenControl.getValue());
		blueControl.setValue(blueControl.getValue());
		if (alphaControl.isEnabled()) {
			alphaControl.changeValue(alphaControl.getValue());
		}
	}

	initColorControls();
	initCanvas();
	webColorFilter = new WebColorFilter($("webColorLabel"), $("webColor"), $("webColorFilter"));
	initFormatter();
	initColors();
	valueChanged();
}

function enableAlpha(checkAlpha) {

	function resyncronyze() {
		if (alphaControl.isEnabled() && alphaControl.isSyncronized()
				&& hasSynchronizeValues()) {
			// Ressincronizar com os outros valores
			for ( var i = 0; i < synchronizedControls.length; i++) {
				if (synchronizedControls[i].getId() != ALPHA) {
					alphaControl.setValue(synchronizedControls[i].getValue());
					break;
				}
			}
		}
	}

	alphaControl.enable();
	resyncronyze();
	valueChanged();
	formatValue();
}

function hasSynchronizeValues() {
	return (synchronizedControls.length > 1);
}

function synchronizeValues(source) {

	function getSyncValue() {
		var sum = 0;
		for (i = 0; i < synchronizedControls.length; i++) {
			sum += parseInt(synchronizedControls[i].getValue());
		}
		return Math.round(sum / synchronizedControls.length);
	}

	function fillSyncValue(value) {
		for (i = 0; i < synchronizedControls.length; i++) {
			synchronizedControls[i].setValue(value);
		}
	}

	function removeControl(control) {
		for (i = 0; i < synchronizedControls.length; i++) {
			if (synchronizedControls[i].getId() == control.getId()) {
				synchronizedControls.splice(i, 1);
				break;
			}
		}
	}
	
	var colorControl = source.colorControl;
	if (colorControl.isSyncronized()) {
		synchronizedControls.push(colorControl);
		if (hasSynchronizeValues()) {
			var syncValue = getSyncValue();
			fillSyncValue(syncValue);
			valueChanged();
		}
	} else {
		removeControl(colorControl);
	}
}

function valueChanged(source) {

	function syncronizeValues(control) {
		if (control.isSyncronized() && hasSynchronizeValues()) {
			for ( var i = 0; i < synchronizedControls.length; i++) {
				if (synchronizedControls[i].getId() != control.getId()) {
					synchronizedControls[i].setValue(control.getValue());
				}
			}
		}
	}

	if (source) {
		var control = source.colorControl;
		control.setValue(source);
		syncronizeValues(control);
	}

	var red = redControl.getValue();
	var green = greenControl.getValue();
	var blue = blueControl.getValue();
	var alpha = alphaControl.isEnabled() ? (alphaControl.getValue() / COLOR_MAX)
			: COLOR_MAX;

	changeColor(red, green, blue, alpha);
	webColorFilter.changeWebColor(red, green, blue);
	formatValue();
}

function randomColor() {

	function randomValue() {
		return Math.round(Math.random() * COLOR_MAX);
	}

	function setValue(colorControl) {
		colorControl.setValue(colorControl.isSyncronized() ? syncValue
				: randomValue());
	}

	var syncValue = randomValue();
	setValue(redControl);
	setValue(greenControl);
	setValue(blueControl);
	if (alphaControl.isEnabled()) {
		setValue(alphaControl);
	}

	valueChanged();
}

function formatValue() {
	var formatter = formatters[$("formatType").selectedIndex];

	$("colorValue").value = formatter.format(redControl.getValue(),
			greenControl.getValue(), blueControl.getValue(), alphaControl
					.getValue(), alphaControl.isEnabled());
}

function changeWebColor() {
	var selectedWebColor = webColorFilter.getWebColor();

	if (selectedWebColor.defined) {
		redControl.setValue(selectedWebColor.red);
		greenControl.setValue(selectedWebColor.green);
		blueControl.setValue(selectedWebColor.blue);

		valueChanged();
	}

	return true;
}


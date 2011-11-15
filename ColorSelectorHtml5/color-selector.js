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

var controlsByColor = [];

/**
 * 
 * @param name
 * @param foregroundFunction
 * @param backgroundFunction
 * @returns
 */
function ColorControl(name, foregroundFunction, backgroundFunction) {

	// Variáveis Internas

	var id = name;
	var syncronizer = $(name + "Sync");
	syncronizer.colorControl = this;
	var label = $(name + "Label");
	var spinner = $(name + "Spinner");
	spinner.colorControl = this;
	var value = spinner.valueAsNumber;
	var cells = [ syncronizer.parentNode, label.parentNode, spinner.parentNode ];
	spinner.colorName = syncronizer.colorName = name;

	// Funções privadas

	var changeControlColor = function() {
		var backColor = backgroundFunction(value);
		for ( var int = 0; int < cells.length; int++) {
			var cell = cells[int];
			cell.style.background = backColor;
		}
		label.style.color = foregroundFunction(value);
	}

	// Funções Públicas

	this.setValue = function(v) {
		if (typeof (v) == "number") {
			value = spinner.value = v;
		} else if (v.type && v.type == "number") {
			value = v.valueAsNumber;
		} else {
			throw new Error("Valor indefinido para alterar o valor de " + id);
		}

		if (id != ALPHA) {
			changeControlColor();
		}
	}

	this.getValue = function() {
		return value;
	}

	this.getLabel = function() {
		return label;
	}

	this.getSyncronyzer = function() {
		return syncronizer;
	}

	this.getSpinner = function() {
		return spinner;
	}

	this.isSyncronized = function() {
		return syncronizer.checked;
	}
	
	this.getId = function() {
		return id;
	}

	this.changeValue = function(source) {
		throw new Error("Acesso inválido para alterar o valor de " + id);

		if (source == spinner) {
			value = source.valueAsNumber;
		}

		if (id != ALPHA) {
			changeControlColor();
		}
	}
}

var redControl, greenControl, blueControl, alphaControl;

/**
 * Função que realiza a troca de cores do canvas.
 */
var changeColor;

var webColorControlVisible;
var webColorsOptions = new Array();

function init() {

	function initColorControls() {
		var foreFunction = function(value) {
			return (value > (COLOR_MAX / 2)) ? "black" : "white";
		};

		redControl = controlsByColor[RED] = new ColorControl(RED, foreFunction,
				function(value) {
					return "rgb(" + value + ", 0, 0)";
				});
		greenControl = controlsByColor[GREEN] = new ColorControl(GREEN,
				foreFunction, function(value) {
					return "rgb(0, " + value + ", 0)";
				});
		blueControl = controlsByColor[BLUE] = new ColorControl(BLUE, function(
				value) {
			return "white";
		}, function(value) {
			return "rgb(0, 0, " + value + ")";
		});

		alphaControl = controlsByColor[ALPHA] = new ColorControl(ALPHA, null,
				null);
		alphaControl.setValue(COLOR_MAX);
		alphaControl.enabler = $("alphaEnabler");
		alphaControl.enable = function() {
			this.getSyncronizer().disabled = this.getSpinner().disabled = !enabler.checked;
			this.getLabel().style.color = enabler.checked ? "black" : "grey";
		}
		alphaControl.isEnabled = function() {
			return enabler.checked;
		}
		alphaControl.getLabel().style.color = "grey";
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

	function initSelectWebColor() {
		var selectWebColor = $("webColor");
		for ( var i = 0; i < WEB_COLORS.length; i++) {
			var webColor = WEB_COLORS[i];
			var option = new Option(webColor.name);
			option.style.background = webColor.name;
			option.style.color = ((webColor.red + webColor.green + webColor.blue) > (COLOR_MAX * 1.5)) ? "black"
					: "white";
			option.webColor = webColor;
			selectWebColor.options[i] = webColorsOptions[i] = option;
		}

		return selectWebColor;
	}

	function initWebColorFilter() {
		var webColorFilter = $("webColorFilter");
		webColorFilter.value = "";
		if (webColorFilter.addEventListener) {
			webColorFilter.addEventListener("keypress", filterWebColorKeyEvent,
					false);
		} else if (webColorFilter.attachEvent) {
			webColorFilter.attachEvent("onkeypress", filterWebColorKeyEvent);
			webColorFilter.attachEvent("onkeydown", function(event) {
				if (event.keyCode == 9) { // Tratamento do TAB para IE.
					filterWebColorKeyEvent(event);
				}

				return true;
			});
		}

		return webColorFilter;
	}

	function initWebColorBehavior(selectWebColor, webColorFilter) {
		webColorControlVisible = selectWebColor;
		selectWebColor.swap = function() {
			selectWebColor.style.display = "none";
			webColorFilter.style.display = "block";
			webColorControlVisible = webColorFilter;
		};
		webColorFilter.swap = function() {
			webColorFilter.style.display = "none";
			selectWebColor.style.display = "block";
			webColorControlVisible = selectWebColor;
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
		// alphaControl.changeValue(alphaControl.getValue());
	}

	initColorControls();
	initCanvas();
	var selectWebColor = initSelectWebColor();
	var webColorFilter = initWebColorFilter();
	initWebColorBehavior(selectWebColor, webColorFilter);
	initFormatter();
	initColors();
	valueChanged();
}

function enableAlpha(checkAlpha) {
	alphaControl.enable();
	// $("selectAlpha").disabled = $("alphaValue").disabled = !enabled;
	if (!alphaControl.isEnabled()) {
		// $("selectAlpha").checked = false;
		// synchronizeValues("alphaValue", false);
	}

	formatValue();
}

function synchronizeValueOld(selectId, synchronize) {
	var select = $(selectId);
	select.synchronized = synchronize;
	var i = -1;

	if (select.synchronized) {
		synchronizedControls.push(select);
		if (synchronizedControls.length > 1) {
			// Calcula o valor m�dio.
			var sum = 0;
			for (i = 0; i < synchronizedControls.length; i++) {
				sum += parseInt(synchronizedControls[i].valueAsNumber);
			}

			var media = Math.round(sum / synchronizedControls.length);

			for (i = 0; i < synchronizedControls.length; i++) {
				synchronizedControls[i].valueAsNumber = media;
			}
		}
	} else {
		for (i = 0; i < synchronizedControls.length; i++) {
			if (synchronizedControls[i].id == select.id) {
				synchronizedControls.splice(i, 1);
				break;
			}
		}
	}
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
		if (synchronizedControls.length > 1) {
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
		if (control.isSyncronized() && synchronizedControls.length > 1) {
			for ( var i = 0; i < synchronizedControls.length; i++) {
				if (synchronizedControls[i].getId() != control.getId()) {
					synchronizedControls[i].setValue(control.getValue());
				}
			}
		}
	}

	function changeWebColor(red, green, blue) {
		var webColorIndex = 0;
		var webColorOptions = $("webColor").options;
		for ( var i = 1; i < webColorOptions.length; i++) {
			if (webColorOptions[i].webColor.isSameColor(red, green, blue)) {
				webColorIndex = i;
				break;
			}
		}
		$("webColor").selectedIndex = webColorIndex;
	}

	if (source) {
		var control = source.colorControl;
		control.setValue(source);
		syncronizeValues(control);
	}

	var red = redControl.getValue();
	var green = greenControl.getValue();
	var blue = blueControl.getValue();

	changeWebColor(red, green, blue);

	// var alpha = alphaControl.isEnabled() ? (alphaControl.getValue() /
	// COLOR_MAX)
	// : COLOR_MAX;
	var alpha = COLOR_MAX;
	changeColor(red, green, blue, alpha);
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
	/*
	 * if (!alphaControl.isEnabled()) { setValue(alphaControl); }
	 */
	valueChanged();
}

function formatValue() {
	var formatter = formatters[$("formatType").selectedIndex];

	$("colorValue").value = formatter.format(redControl.getValue(),
			greenControl.getValue(), blueControl.getValue(), alphaControl
					.getValue(), false);
	// alphaControl.isEnabled());
}

function changeWebColor() {
	var selectedWebColor = $("webColor").options[[ $("webColor").selectedIndex ]].webColor;

	if (selectedWebColor.defined) {
		redControl.setValue(selectedWebColor.red);
		greenControl.setValue(selectedWebColor.green);
		blueControl.setValue(selectedWebColor.blue);

		valueChanged();
	}

	return true;
}

function swapWebColorControl() {
	webColorControlVisible.swap();
	webColorControlVisible.focus();
	$("webColorLabel").htmlFor = webColorControlVisible.id;
}

function filterWebColors() {
	var webColorFilter = $("webColorFilter");
	var selectWebColor = $("webColor");
	selectWebColor.options.length = 0;

	if (webColorFilter.value && !/\s+/.test(webColorFilter.value)) {
		selectWebColor.options[0] = webColorsOptions[0];
		j = 1;
		for ( var i = 1; i < webColorsOptions.length; i++) {
			if (webColorsOptions[i].text.indexOf(webColorFilter.value) >= 0) {
				selectWebColor.options[j] = webColorsOptions[i];
				j++;
			}
		}
	} else {
		for ( var i = 0; i < webColorsOptions.length; i++) {
			selectWebColor.options[i] = webColorsOptions[i];
		}
	}

	swapWebColorControl();
}

function filterWebColorKeyEvent(event) {
	// event: FF & Chrome & IE >= 8; window.event: IE < 7
	if (!event)
		event = window.event;
	// 
	var keyCode = event.keyCode || event.which;

	// keyCode == 9: ENTER && keyCode == 13: TAB
	if ((keyCode == 9) || (keyCode == 13)) {
		filterWebColors();
	}

	return true;
}
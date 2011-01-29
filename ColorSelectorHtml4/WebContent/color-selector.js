var COLOR_MIN = 0;
var COLOR_MAX = 255;

var synchronizedSelects = [];

/**
 * Função que realiza a troca de cores do canvas.
 */
var changeColor;

var webColorControlVisible;
var webColorsOptions = new Array();

function $(id) {
	return document.getElementById(id);
}

function init() {

	function fillColorValues(idSelect) {
		var selectObject = $(idSelect);
		for ( var i = COLOR_MIN; i <= COLOR_MAX; i++) {
			selectObject.options[i] = new Option(i);
		}
	}
	
	function previousNode(node) {
		/* node.previousSibling.nodeType == 3 -> TEXT_NODE (FF, CHROME)
		 * node.previousSibling.nodeType == 1 -> ELEMENT_NODE (IE)
		 */ 
		return (node.previousSibling.nodeType == 3)? 
				node.previousSibling.previousSibling: node.previousSibling;
	}

	function initSelectValues(selectId, backgroundFunction, foregroundFunction) {
		var selectValue = $(selectId);
		fillColorValues(selectId);
		selectValue.selectedIndex = 0;

		selectValue.changeColors = function() {
			var tdSelect = selectValue.parentNode;
			var tdLabel = previousNode(tdSelect);
			var label = tdLabel.firstChild;
			var tdCheck = previousNode(tdLabel);

			tdSelect.style.background = tdLabel.style.background = 
				label.style.background = tdCheck.style.background = 
				backgroundFunction(selectValue.selectedIndex);
			label.style.color = foregroundFunction(selectValue.selectedIndex);
		};
	}

	initSelectValues("redValue", 
			function(value){ return "rgb(" + value + ", 0, 0)";}, 
			function(value){ return (value > (COLOR_MAX / 2))? "black" : "white"; });
	initSelectValues("greenValue", 
			function(value){ return "rgb(0, " + value + ", 0)";}, 
			function(value){ return (value > (COLOR_MAX / 2))? "black" : "white"; });
	initSelectValues("blueValue", 
			function(value){ return "rgb(0, 0, " + value + ")";}, 
			function(value){ return "white"; });
	
	fillColorValues("alphaValue");
	$("alphaValue").selectedIndex = COLOR_MAX;
	$("selectAlpha").checked = $("enableAlpha").checked = false;
	$("alphaValue").disabled = $("selectAlpha").disabled = true;

	var canvas = $("canvas");
	changeColor = canvas.filters ? function(r, g, b, a) { // IE
		canvas.style.backgroundColor = "rgb(" + r + ", " + g + ", " + b
				+ ")";
		canvas.style.filter = "alpha(opacity=" + (100 * a) + ")";
	} : function(r, g, b, a) { // W3C
		canvas.style.backgroundColor = "rgba(" + r + ", " + g + ", " + b
				+ ", " + a + ")";
	};

	var selectWebColor = $("webColor");
	for ( var i = 0; i < WEB_COLORS.length; i++) {
		var webColor = WEB_COLORS[i];
		var option = new Option(webColor.name);
		option.style.background = webColor.name;
		option.style.color = ((webColor.red + webColor.green + webColor.blue) > (COLOR_MAX * 1.5)) ? "black" : "white";
		option.webColor = webColor;
		selectWebColor.options[i] = webColorsOptions[i] = option;
	}
	
	var webColorFilter = $("webColorFilter");
	webColorFilter.value = "";
	if(webColorFilter.addEventListener) {
		webColorFilter.addEventListener("keypress", filterWebColorKeyEvent, false);
	} else if(webColorFilter.attachEvent) {
		webColorFilter.attachEvent("onkeypress", filterWebColorKeyEvent);
		webColorFilter.attachEvent("onkeydown", function(event) {
			if(event.keyCode == 9) { // Tratamento do TAB para IE.
				filterWebColorKeyEvent(event);
			}
			
			return true;
		});
	}
	
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

	// Initialize Color Format Combo
	var selectFormat = $("formatType");
	for ( var i = 0; i < formatters.length; i++) {
		selectFormat.options[i] = new Option(formatters[i].name);
	}

	valueChanged(null);
	
}

function enableAlpha(checkAlpha) {
	var enabled = checkAlpha.checked;
	$("selectAlpha").disabled = $("alphaValue").disabled = !enabled;
	if (!enabled) {
		$("selectAlpha").checked = false;
		synchronizeValues("alphaValue", false);
	}

	formatValue();
}

function synchronizeValues(selectId, synchronize) {
	var select = $(selectId);
	select.synchronized = synchronize;
	var i = -1;

	if (select.synchronized) {
		synchronizedSelects.push(select);
		if (synchronizedSelects.length > 1) {
			// Calcula o valor médio.
			var sum = 0;
			for (i = 0; i < synchronizedSelects.length; i++) {
				sum += parseInt(synchronizedSelects[i].selectedIndex);
			}

			var media = Math.round(sum / synchronizedSelects.length);

			for (i = 0; i < synchronizedSelects.length; i++) {
				synchronizedSelects[i].selectedIndex = media;
			}
		}
	} else {
		for (i = 0; i < synchronizedSelects.length; i++) {
			if (synchronizedSelects[i].id == select.id) {
				synchronizedSelects.splice(i, 1);
				break;
			}
		}
	}
}

function valueChanged(selectSource) {
	// console.log(selectSource.id + " - " + selectSource.value);
	if (selectSource && selectSource.synchronized
			&& (synchronizedSelects.length > 1)) {
		for ( var i = 0; i < synchronizedSelects.length; i++) {
			if (synchronizedSelects[i].id != selectSource.id) {
				synchronizedSelects[i].selectedIndex = selectSource.selectedIndex;
			}
		}
	}

	var red = $("redValue").selectedIndex;
	var green = $("greenValue").selectedIndex;
	var blue = $("blueValue").selectedIndex;

	var webColorIndex = 0;
	var webColorOptions = $("webColor").options;
	for ( var i = 1; i < webColorOptions.length; i++) {
		if (webColorOptions[i].webColor.isSameColor(red, green, blue)) {
			webColorIndex = i;
			break;
		}
	}
	$("webColor").selectedIndex = webColorIndex;

	var alpha = $("alphaValue").disabled ? COLOR_MAX
			: ($("alphaValue").selectedIndex / COLOR_MAX);
	changeColor(red, green, blue, alpha);
	$("redValue").changeColors();
	$("greenValue").changeColors();
	$("blueValue").changeColors();
	formatValue();
}

function randomColor() {
	var syncValue = Math.round(Math.random() * COLOR_MAX);

	function setValue(id) {
		var select = $(id);
		select.selectedIndex = select.synchronized ? syncValue : Math
				.round(Math.random() * COLOR_MAX);
	}

	setValue("redValue");
	setValue("greenValue");
	setValue("blueValue");
	if (!$("alphaValue").disabled) {
		setValue("alphaValue");
	}

	valueChanged(null);
}

function formatValue() {
	var formatter = formatters[$("formatType").selectedIndex];

	$("colorValue").value = formatter.format($("redValue").selectedIndex,
			$("greenValue").selectedIndex, $("blueValue").selectedIndex,
			$("alphaValue").selectedIndex, $("enableAlpha").checked);
}

function changeWebColor() {
	var selectedWebColor = $("webColor").options[[$("webColor").selectedIndex]].webColor;

	if (selectedWebColor.defined) {
		$("redValue").selectedIndex = selectedWebColor.red;
		$("greenValue").selectedIndex = selectedWebColor.green;
		$("blueValue").selectedIndex = selectedWebColor.blue;

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
	
	if(webColorFilter.value && !/\s+/.test(webColorFilter.value)) {
		selectWebColor.options[0] = webColorsOptions[0];
		j = 1;
		for (var i = 1; i < webColorsOptions.length; i++) {
			if(webColorsOptions[i].text.indexOf(webColorFilter.value) >= 0) {
				selectWebColor.options[j] = webColorsOptions[i];
				j ++;
			}
		}
	} else {
		for (var i = 0; i < webColorsOptions.length; i++) {
			selectWebColor.options[i] = webColorsOptions[i];
		}
	}
	
	swapWebColorControl();
}

function filterWebColorKeyEvent(event) {
	// event: FF & Chrome & IE >= 8; window.event: IE < 7
	if(!event) event = window.event;
	// 
	var keyCode = event.keyCode || event.which;
	
	// keyCode == 9: ENTER && keyCode == 13: TAB
	if((keyCode == 9) || (keyCode == 13)) {
		filterWebColors();
	}
	
	return true; 
}
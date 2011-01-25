
var COLOR_MIN = 0;
var COLOR_MAX = 255;

var synchronizedSelects = [];

/**
 * Função que realiza a troca de cores do canvas.
 */
var changeColor;

function $(id) {
	return document.getElementById(id);
}

function init() {
	
	function fillColorValues(idSelect) {
		var selectObject = $(idSelect);
		for(var i = COLOR_MIN; i <= COLOR_MAX; i ++) {
			selectObject.options[i] = new Option(i);
		}
	}
	
	fillColorValues("redValue");
	fillColorValues("greenValue");
	fillColorValues("blueValue");
	fillColorValues("alphaValue");
	
	$("redValue").selectedIndex = $("redValue").selectedIndex 
		= $("redValue").selectedIndex = 0;
	$("alphaValue").selectedIndex = COLOR_MAX;
	$("selectRed").checked = $("selectGreen").checked = $("selectBlue").checked 
		= $("selectAlpha").checked = $("enableAlpha").checked = false;
	$("alphaValue").disabled = $("selectAlpha").disabled = true;

	
	changeColor = $("canvas").filters? 
		function(r, g, b, a) { // IE
			$("canvas").style.backgroundColor = "rgb(" + r + ", " + g + ", " + b + ")";
			$("canvas").style.filter = "alpha(opacity=" + (100 * a) + ")";
		} : 
		function(r, g, b, a) { // W3C
			$("canvas").style.backgroundColor = "rgba(" + r + ", " + g + ", " + b + ", " + a + ")";
		};
	
	// Initialize Color Format Combo
	var selectFormat = $("formatType");
	for(var i = 0; i < formatters.length; i ++) {
		selectFormat.options[i] = new Option(formatters[i].name);
	}

	valueChanged(null);
}

function enableAlpha(checkAlpha) {
	var enabled = checkAlpha.checked;
	$("selectAlpha").disabled = $("alphaValue").disabled = !enabled;
	if(!enabled) {
		$("selectAlpha").checked = false;
		synchronizeValues("alphaValue", false);
	}
	
	formatValue();
}

function roundNumber(value) {
	var result;
	
	if(value >= 100) {
		result = value.toPrecision(3);
	} else if(value >= 10) {
		result = value.toPrecision(2);
	} else {
		result = value.toPrecision(1);
	}
	
	return result;
}

function synchronizeValues(selectId, synchronize) {
	var select = $(selectId);
	select.synchronized =  synchronize;
	var i = -1;
	
	if(select.synchronized) {
		synchronizedSelects.push(select);
		if(synchronizedSelects.length > 1) {
			// Calcula o valor médio.
			var sum = 0;
			for(i = 0; i < synchronizedSelects.length; i ++) {
				sum += parseInt(synchronizedSelects[i].selectedIndex);
			}
			
			var media = Math.round(sum / synchronizedSelects.length);
			
			for(i = 0; i < synchronizedSelects.length; i ++) {
				synchronizedSelects[i].selectedIndex = media;
			}
		}
	} else {
		for(i = 0; i < synchronizedSelects.length; i ++) {
			if(synchronizedSelects[i].id == select.id) {
				synchronizedSelects.splice(i, 1);
				break;
			}
		}
	}
}


function valueChanged(selectSource) {
//	console.log(selectSource.id + " - " + selectSource.value); 
	if(selectSource && selectSource.synchronized && (synchronizedSelects.length > 1)) {
		for(var i = 0; i < synchronizedSelects.length; i ++) {
			if(synchronizedSelects[i].id != selectSource.id) {
				synchronizedSelects[i].selectedIndex = selectSource.selectedIndex;
			}
		}
	}
	
	var alpha = $("alphaValue").disabled? COLOR_MAX: ($("alphaValue").selectedIndex / COLOR_MAX);
	changeColor($("redValue").selectedIndex, $("greenValue").selectedIndex, $("blueValue").selectedIndex, alpha);
	formatValue();
}

function randomColor() {
	var syncValue = Math.round(Math.random() * COLOR_MAX);

	function setValue(id) {
		var select = $(id);
		select.selectedIndex = select.synchronized? syncValue: Math.round(Math.random() * COLOR_MAX);
	}
	
	setValue("redValue");
	setValue("greenValue");
	setValue("blueValue");
	if(!$("alphaValue").disabled) {
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
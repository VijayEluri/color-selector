
var COLOR_MIN = 0;
var COLOR_MAX = 255;

var synchronizedSelects = [];

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
	
	$("redValue").selectedIndex = $("redValue").selectedIndex = $("redValue").selectedIndex = 0;
	$("alphaValue").selectedIndex = COLOR_MAX;
	$("selectRed").checked = $("selectGreen").checked = $("selectBlue").checked = $("selectAlpha").checked = $("enableAlpha").checked = false;
	
	
	changeColor = $("canvas").filters? 
		function(r, g, b, a) {
			$("canvas").style.backgroundColor = "rgb(" + r + ", " + g + ", " + b + ")";
			$("canvas").style.filter = "alpha(opacity=" + (100 * a) + ")";
		} : 
		function(r, g, b, a) {
			$("canvas").style.backgroundColor = "rgba(" + r + ", " + g + ", " + b + ", " + a + ")";
		};
	
	valueChanged(null);
}

function enableAlpha(checkAlpha) {
	var enabled = checkAlpha.checked;
	$("selectAlpha").disabled = $("alphaValue").disabled = !enabled;
	if(!enabled) {
		$("selectAlpha").checked = false;
		synchronizeValues("alphaValue", false);
	}
}

function synchronizeValues(selectId, synchronize) {
	var select = $(selectId);
	var i = -1;
	
	if(synchronize) {
		synchronizedSelects.push(select);
		if(synchronizedSelects.length > 1) {
			// Calcula o valor médio.
			select.synchronized = true;
			var sum = 0;
			for(i = 0; i < synchronizedSelects.length; i ++) {
				sum += parseInt(synchronizedSelects[i].selectedIndex);
			}
			var media = sum / synchronizedSelects.length;
			if(media >= 100) {
				media = media.toPrecision(3);
			} else if(media >= 10) {
				media = media.toPrecision(2);
			} else {
				media = media.toPrecision(1);
			}
			for(i = 0; i < synchronizedSelects.length; i ++) {
				synchronizedSelects[i].selectedIndex = media;
			}
		}
	} else {
		for(i = 0; i < synchronizedSelects.length; i ++) {
			if(synchronizedSelects[i].id == select.id) {
				synchronizedSelects.splice(i, 1);
				select.synchronized = false;
				break;
			}
		}
	}
}

/**
 * Função que realiza a troca de cores do canvas.
 */
var changeColor;


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
}
/**
 * Classe que coordena a seleção de {@link WebColor}s.
 * 
 * @param webColorLabel
 *            Label indicando os controles de QebColor no qual o duplo clique
 *            trocará entre o webColorSelector e o webColorFilter
 * @param webColorSelector
 *            <SELECT> com a relação de WebColors.
 * @param webColorFilter
 *            Campo texto usado para filtra os WebColors que devem aparecer em
 *            webColorSelector.
 * 
 */
function WebColorFilter(webColorLabel, webColorSelector, webColorFilter) {

	var webColorControlVisible;

	var webColorsOptions = new Array();

	function initWebColorSelector() {
		for ( var i = 0; i < WEB_COLORS.length; i++) {
			var webColor = WEB_COLORS[i];
			var option = new Option(webColor.name);
			option.style.background = webColor.name;
			option.style.color = ((webColor.red + webColor.green + webColor.blue) > (COLOR_MAX * 1.5)) ? "black"
					: "white";
			option.webColor = webColor;
			webColorSelector.options[i] = webColorsOptions[i] = option;
		}
	}

	function initWebColorFilter() {
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

	function initWebColorBehavior() {
		webColorSelector.swap = function() {
			webColorSelector.style.display = "none";
			webColorFilter.style.display = "block";
			webColorControlVisible = webColorFilter;
		};
		webColorFilter.swap = function() {
			webColorFilter.style.display = "none";
			webColorSelector.style.display = "block";
			webColorControlVisible = webColorSelector;
		};
	}

	function init() {
		webColorLabel.ondblclick = swapWebColorControl;
		webColorFilter.onchange = filterWebColors;

		webColorSelector.other = webColorFilter;
		webColorFilter.other = webColorSelector;
		webColorControlVisible = webColorSelector;

		initWebColorSelector();
		initWebColorFilter();
		initWebColorBehavior();
	}

	function swapWebColorControl() {
		webColorControlVisible.swap();
		webColorControlVisible.focus();
		webColorLabel.htmlFor = webColorControlVisible.id;
	}

	function filterWebColors() {
		webColorSelector.options.length = 0;

		if (webColorFilter.value && !/\s+/.test(webColorFilter.value)) {
			webColorSelector.options[0] = webColorsOptions[0];
			j = 1;
			for ( var i = 1; i < webColorsOptions.length; i++) {
				if (webColorsOptions[i].text.indexOf(webColorFilter.value) >= 0) {
					webColorSelector.options[j] = webColorsOptions[i];
					j++;
				}
			}
		} else {
			for ( var i = 0; i < webColorsOptions.length; i++) {
				webColorSelector.options[i] = webColorsOptions[i];
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

	this.changeWebColor = function(red, green, blue) {
		var webColorIndex = 0;
		var webColorOptions = webColorSelector.options;
		for ( var i = 1; i < webColorOptions.length; i++) {
			if (webColorOptions[i].webColor.isSameColor(red, green, blue)) {
				webColorIndex = i;
				break;
			}
		}
		webColorSelector.selectedIndex = webColorIndex;
	}

	this.getWebColor = function() {
		return webColorSelector.options[webColorSelector.selectedIndex].webColor;
	}

	init();
}
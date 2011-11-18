/**
 * Agrupa os componentes relacionados a determinada cor.
 * 
 * @param name
 *            Identificação do controle.
 * @param foregroundFunction
 *            Função para alterar a cor da fonte do label.
 * @param backgroundFunction
 *            Função para alterar a cor da fonte dos campos.
 */
function ColorControl(name, foregroundFunction, backgroundFunction) {

	// Variáveis Internas

	if (name) {
		var id = name;
		var syncronizer = $(name + "Sync");
		syncronizer.colorControl = this;
		var label = $(name + "Label");
		var slider = $(name + "Slider");
		slider.colorControl = this;
		var spinner = $(name + "Spinner");
		spinner.colorControl = this;
		var value = spinner.valueAsNumber;
		var cells = [ syncronizer.parentNode, label.parentNode,
				slider.parentNode, spinner.parentNode ];
		slider.colorName = spinner.colorName = syncronizer.colorName = name;
	}

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
			value = slider.value = spinner.value  = v;
		} else if (v == spinner) {
			value = slider.value = spinner.valueAsNumber;
		} else if (v == slider) {
			value = spinner.value = slider.valueAsNumber;
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

	this.getSlider = function() {
		return slider;
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

	this.toString = function() {
		return this.getId() + "[value = " + this.getValue()
				+ ", syncronized = " + this.isSyncronized() + "]";
	}

}

/**
 * Agrupa os componentes relacionados ao controle da transparência (Alpha).
 * 
 * @param name
 *            Identificação do controle.
 */
function AlphaControl(name) {
	// Inheritance Strategy: See
	// http://www.cs.rit.edu/~atk/JavaScript/manuals/jsobj/index.htm#1044609
	this.colorControl = ColorControl;
	this.colorControl(name);

	this.getLabel().style.color = "grey";
	this.setValue(COLOR_MAX);
	var enabler = $("alphaEnabler");

	this.enable = function() {
		this.getLabel().style.color = enabler.checked ? "black" : "grey";
		this.getSyncronyzer().disabled = this.getSlider().disabled = this
				.getSpinner().disabled = !enabler.checked;
	}

	this.isEnabled = function() {
		return enabler.checked;
	}

}

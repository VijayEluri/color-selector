/**
 * 
 * @param name
 * @param foregroundFunction
 * @param backgroundFunction
 * @returns
 */
function ColorControl(name, foregroundFunction, backgroundFunction) {

	// Variáveis Internas

	if (name) {
		var id = name;
		var syncronizer = $(name + "Sync");
		syncronizer.colorControl = this;
		var label = $(name + "Label");
		var spinner = $(name + "Spinner");
		spinner.colorControl = this;
		var value = spinner.valueAsNumber;
		var cells = [ syncronizer.parentNode, label.parentNode,
				spinner.parentNode ];
		spinner.colorName = syncronizer.colorName = name;
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

	this.toString = function() {
		return this.getId() + "[value = " + this.getValue()
				+ ", syncronized = " + this.isSyncronized() + "]";
	}

}

function AlphaControl(name) {
	this.colorControl = ColorControl;
	this.colorControl(name);

	this.getLabel().style.color = "grey";
	this.setValue(COLOR_MAX);
	var enabler = $("alphaEnabler");

	this.enable = function() {
		this.getLabel().style.color = enabler.checked ? "black" : "grey";
		this.getSyncronyzer().disabled = this.getSpinner().disabled = !enabler.checked;
	}

	this.isEnabled = function() {
		return enabler.checked;
	}

}


/**
 * 
 */

function formatInt(n) {
	var strNum = n.toString();
	
	switch (strNum.length) {
		case 1: return "  " + strNum;
		case 2: return " " + strNum;
		case 3: return strNum;
	}
}

function formatInt1(n) {
	if(n < 1) {
		return "  0";
	} else if(n < 10) {
		return "  " + n.toPrecision(1);
	} else if(n < 100) {
		return " " + n.toPrecision(2);
	} else {
		return n.toPrecision(3);
	}
}

function formatDouble(d) {
	if(d < 0.01) {
		return "0.00";
	} else if(d < 0.1) {
		return d.toPrecision(1);
	} else if(d < 1) {
		return d.toPrecision(2);
	} else {
		return d.toPrecision(3);
	}
}

function getH(r, g, b, max, min) {
	var c = max - min;
	var g = 0;
	
	if(c == 0) {
		h = 0;
	} else if(max == r) {
		h = ((g - b) / c) % 6;
	} else if(max == g) {
		h = (b - r) / c + 2;
	} else { // (max == b)
		h = (r - g) / c + 4;
	}
	
	return 60 * h;
}

var formatters = [ 
	{
		name : "Hexadecimal",
		format : function(r, g, b, a, hasAlpha) {
			function formatHexa(n) {
				var strNum = n.toString(16).toUpperCase();
				
				return (strNum.length == 1)? "0" + strNum: strNum;
			}
		
			return "#" + formatHexa(r) + formatHexa(g) + formatHexa(b);
		}
	}, 
	{
		name : "RGB",
		format : function(r, g, b, a, hasAlpha) {
			var str1 = formatInt(r) + ", " + formatInt(g) + ", " + formatInt(b);
			
			return hasAlpha? 
				"rgba(" + str1 + ", " + formatDouble(a / COLOR_MAX) + ")" : 
				"rgb(" + str1 + ")";
		}
	},
	{
		name: "Percent",
		format : function(r, g, b, a, hasAlpha) {
			function toPercent(n) {
				var percent = ((100 * n) / COLOR_MAX);
				 
				if(percent < 1) {
					return "  0";
				} else if(percent < 10) {
					return "  " + percent.toPrecision(1);
				} else if(percent < 100) {
					return " " + percent.toPrecision(2);
				} else {
					return percent.toPrecision(3);
				}
			}
			
			var str1 = formatInt1(r * 100 / COLOR_MAX) + "%, " 
				+ formatInt1(g * 100 / COLOR_MAX) + "%, " 
				+ formatInt1(b * 100 / COLOR_MAX) + "%";
			
			return hasAlpha? 
				"rgba(" + str1 + ", " + formatDouble(a / COLOR_MAX) + ")" : 
				"rgb(" + str1 + ")";
		}
	}
	/*
	,
	{
		name: "HSL",
		format : function(r, g, b, a, hasAlpha) {
			var _r = r / COLOR_MAX;
			var _g = g / COLOR_MAX;
			var _b = b / COLOR_MAX;
			var _a = a / COLOR_MAX;
			
			var max = Math.max(Math.max(r, g), b);
			var min = Math.min(Math.min(r, g), b);
			
			var h = getH(r, g, b, max, min);
			var l = (max + min) / (2 * COLOR_MAX);
			var s = (max == min)? 0: (max - min) / (1 - Math.abs(2 * l - 1)) / COLOR_MAX;
			
			var str1 = formatInt1(h) + ", " + formatDouble(s) + ", " + formatDouble(l);
			return hasAlpha?
					"hsla(" + str1 + ", " + formatDouble(a / COLOR_MAX) + ")" :
					"hsl(" + str1 + ")";
		}
	}
	*/
];
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package colorselector;

import java.lang.String;
import java.util.Locale;
import javafx.scene.paint.Color;

function formatAlpha(alpha: Number): String {
    String.format(Locale.US, "%.2f", alpha)
}

/**
 * @author rafael
 */
public abstract class ColorFormatter {

    public-init var description: String;

    abstract public function format(c: Color, hasAlpha: Boolean): String;

    override function toString(): String {
        description
    }

}

class Hexadecimal extends ColorFormatter {

    override var description = "Hexadecimal";

    override function format(c: Color, hasAlpha: Boolean): String {
        "#{%02x Utils.colorValueToInt(c.red)}{%02x Utils.colorValueToInt(c.green)}{%02x Utils.colorValueToInt(c.blue)}".toUpperCase();
    }
}

class Rgb extends ColorFormatter {
    override var description = "RGB";

    function formatWithAlpha(c: Color): String {
        "rgba({%03d Utils.colorValueToInt(c.red)}, {%03d Utils.colorValueToInt(c.green)}, {%03d Utils.colorValueToInt(c.blue)}, {formatAlpha(c.opacity)})";
    }

    function formatWithoutAlpha(c: Color): String {
        "rgb({%03d Utils.colorValueToInt(c.red)}, {%03d Utils.colorValueToInt(c.green)}, {%03d Utils.colorValueToInt(c.blue)})";
    }

    override public function format (c : Color, hasAlpha : Boolean) : String {
        if(hasAlpha) formatWithAlpha(c) else formatWithoutAlpha(c)
    }
}

/**
 * See http://www.w3.org/TR/css3-color/#rgba-color
 */
class Percent extends ColorFormatter {

    override var description = "Percent";

    function formatPercent(n: Number): String {
        "{%3.0f (n * 100)}%"
    }

    function formatWithAlpha(c: Color): String {
        "rgba({formatPercent(c.red)}, {formatPercent(c.green)}, {formatPercent(c.blue)}, {formatAlpha(c.opacity)})"
    }

    function formatWithoutAlpha(c: Color): String {
        "rgb({formatPercent(c.red)}, {formatPercent(c.green)}, {formatPercent(c.blue)})"
    }

    override public function format (c : Color, hasAlpha : Boolean) : String {
        if(hasAlpha) formatWithAlpha(c) else formatWithoutAlpha(c)
    }
}

public def formatters: ColorFormatter[] = [Hexadecimal{}, Rgb{}, Percent{}];

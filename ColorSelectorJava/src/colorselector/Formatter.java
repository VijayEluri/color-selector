/**
 * 
 */
package colorselector;

import java.awt.Color;
import java.awt.Component;
import java.util.Locale;

import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.plaf.basic.BasicComboBoxRenderer;

/**
 * @author rafael
 * 
 */
public enum Formatter {

    /**
     * @see <a
     *      href="http://www.w3.org/TR/css3-color/#numerical">http://www.w3.org/TR/css3-color/#numerical</a>
     */
    HEX("Hexadecimal") {
        private static final String HEXADECIMAL_FORMAT = "#%02x%02x%02x";

        @Override
        protected String formatWithAlpha(Color c) {
            return formatWithoutAlpha(c);
        }

        @Override
        protected String formatWithoutAlpha(Color c) {
            return String.format(HEXADECIMAL_FORMAT, c.getRed(), c.getGreen(),
                    c.getBlue()).toUpperCase();
        }
    },
    /**
     * @see <a
     *      href="http://www.w3.org/TR/css3-color/#rgba-color">http://www.w3.org/TR/css3-color/#rgba-color</a>
     * @see <a
     *      href="http://www.w3.org/TR/css3-color/#rgb-color">http://www.w3.org/TR/css3-color/#rgb-color</a>
     */
    RGB("RGB") {
        private static final String RGB_FORMAT = "rgb(%3d, %3d, %3d)";
        private static final String RGBA_FORMAT = "rgba(%3d, %3d, %3d, %.2f)";

        @Override
        protected String formatWithAlpha(Color c) {
            return String.format(Locale.US, RGBA_FORMAT, c.getRed(),
                    c.getGreen(), c.getBlue(), toHexProportion(c.getAlpha()));
        }

        @Override
        protected String formatWithoutAlpha(Color c) {
            return String.format(Locale.US, RGB_FORMAT, c.getRed(),
                    c.getGreen(), c.getBlue());
        }

    },
    /**
     * @see <a
     *      href="http://www.w3.org/TR/css3-color/#rgba-color">http://www.w3.org/TR/css3-color/#rgba-color</a>
     * @see <a
     *      href="http://www.w3.org/TR/css3-color/#rgb-color">http://www.w3.org/TR/css3-color/#rgb-color</a>
     */
    PERCENT("Percent") {
        private final String RGB_FORMAT = "rgb(%3d%%, %3d%%, %3d%%)";
        private final String RGBA_FORMAT = "rgba(%3d%%, %3d%%, %3d%%, %.2f)";

        private int toHexPercent(int value) {
            return (int) (100 * toHexProportion(value));
        }

        @Override
        protected String formatWithAlpha(Color c) {
            return String.format(Locale.US, RGBA_FORMAT,
                    toHexPercent(c.getRed()), toHexPercent(c.getGreen()),
                    toHexPercent(c.getBlue()), toHexProportion(c.getAlpha()));
        }

        @Override
        protected String formatWithoutAlpha(Color c) {
            return String.format(Locale.US, RGB_FORMAT,
                    toHexPercent(c.getRed()), toHexPercent(c.getGreen()),
                    toHexPercent(c.getBlue()));
        }

    },
    /**
     * @see <a
     *      href="http://www.w3.org/TR/css3-color/#hsl-color">http://www.w3.org/TR/css3-color/#hsl-color</a>
     * @see <a
     *      href="http://www.w3.org/TR/css3-color/#hsla-color">http://www.w3.org/TR/css3-color/#hsla-color</a>
     * @see <a
     *      href="http://en.wikipedia.org/wiki/HSL_and_HSV">http://en.wikipedia.org/wiki/HSL_and_HSV</a>
     * @see Color#RGBtoHSB(int, int, int, float[])
     */
    HSB("HSB (HSV)") {
        private final String HSL_FORMAT = "hsl(%3d, %3d%%, %3d%%)";
        private final String HSLA_FORMAT = "hsla(%3d, %3d%%, %3d%%, %.2f)";

        private int[] colorToHsbValues(Color c) {
            float[] hsl = Color.RGBtoHSB(c.getRed(), c.getGreen(), c.getBlue(),
                    null);
            
            return new int[] { (int) (hsl[0] * 360), (int) (hsl[1] * 100),
                    (int) (hsl[2] * 100) };
        }

        @Override
        protected String formatWithAlpha(Color c) {
            int[] hsbValues = this.colorToHsbValues(c);

            return String.format(Locale.US, HSLA_FORMAT, hsbValues[0],
                    hsbValues[1], hsbValues[2], toHexProportion(c.getAlpha()));
        }

        @Override
        protected String formatWithoutAlpha(Color c) {
            int[] hsbValues = this.colorToHsbValues(c);

            return String.format(Locale.US, HSL_FORMAT, hsbValues[0],
                    hsbValues[1], hsbValues[2]);
        }

    };

    private String description;

    private Formatter(String description) {
        this.description = description;
    }

    protected float toHexProportion(int value) {
        return ((float) value) / 255;
    }

    protected abstract String formatWithAlpha(Color c);

    protected abstract String formatWithoutAlpha(Color c);

    public String format(Color c, boolean hasAlpha) {
        return hasAlpha ? formatWithAlpha(c) : formatWithoutAlpha(c);
    }

    public String getDescription() {
        return description;
    }

}

class FormatterRenderer extends BasicComboBoxRenderer {

    /**
     * 
     */
    private static final long serialVersionUID = -8944125965210305962L;

    @Override
    public Component getListCellRendererComponent(JList list, Object value,
            int index, boolean isSelected, boolean cellHasFocus) {
        Component component = super.getListCellRendererComponent(list, value,
                index, isSelected, cellHasFocus);

        Formatter formatter = (Formatter) value;
        ((JLabel) component).setText(formatter.getDescription());

        return component;
    }

}
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

    HEX("Hexadecimal") {
        private static final String HEXADECIMAL_FORMAT = "#%02x%02x%02x";

        @Override
        public String format(Color c, boolean hasAlpha) {
            return String.format(HEXADECIMAL_FORMAT, c.getRed(), c.getGreen(),
                    c.getBlue()).toUpperCase();
        }
    },
    RGB("RGB") {
        private static final String RGB_FORMAT = "rgb(%3d, %3d, %3d)";
        private static final String RGBA_FORMAT = "rgba(%3d, %3d, %3d, %.2f)";

        /**
         * See http://www.w3.org/TR/css3-color/#rgba-color
         * 
         * @param c
         * @return
         */
        private String formatWithAlpha(Color c) {
            return String.format(Locale.US, RGBA_FORMAT, c.getRed(),
                    c.getGreen(), c.getBlue(), toHexProportion(c.getAlpha()));
        }

        /**
         * See http://www.w3.org/TR/css3-color/#rgb-color
         * 
         * @param c
         * @return
         */
        private String formatWithOutAlpha(Color c) {
            return String.format(Locale.US, RGB_FORMAT, c.getRed(),
                    c.getGreen(), c.getBlue());
        }

        @Override
        public String format(Color c, boolean hasAlpha) {
            return hasAlpha ? formatWithAlpha(c) : formatWithOutAlpha(c);
        }
    },
    PERCENT("Percent") {
        private final String RGB_FORMAT = "rgb(%3d%%, %3d%%, %3d%%)";
        private final String RGBA_FORMAT = "rgba(%3d%%, %3d%%, %3d%%, %.2f)";

        private int toHexPercent(int value) {
            return (int) (100 * toHexProportion(value));
        }

        /**
         * See http://www.w3.org/TR/css3-color/#rgba-color
         * 
         * @param c
         * @return
         */
        private String formatWithAlpha(Color c) {
            return String.format(Locale.US, RGBA_FORMAT,
                    toHexPercent(c.getRed()), toHexPercent(c.getGreen()),
                    toHexPercent(c.getBlue()), toHexProportion(c.getAlpha()));
        }

        /**
         * See http://www.w3.org/TR/css3-color/#rgb-color
         * 
         * @param c
         * @return
         */
        private String formatWithOutAlpha(Color c) {
            return String.format(Locale.US, RGB_FORMAT,
                    toHexPercent(c.getRed()), toHexPercent(c.getGreen()),
                    toHexPercent(c.getBlue()));
        }

        @Override
        public String format(Color c, boolean hasAlpha) {
            return hasAlpha ? formatWithAlpha(c) : formatWithOutAlpha(c);
        }
    },
    HSL("HSL") {

        private final String HSL_FORMAT = "hsl(%.2f, %.2f, %.2f)";
        private final String HSLA_FORMAT = "hsla(%.2f, %.2f, %.2f, %.2f)";

        private String formatWithoutAlpha(float[] hsl) {
            return String.format(Locale.US, HSL_FORMAT, hsl[0], hsl[1], hsl[2]);
        }

        private String formatWithAlpha(Color c, float[] hsl) {
            return String.format(Locale.US, HSLA_FORMAT, hsl[0], hsl[1],
                    hsl[2], super.toHexProportion(c.getAlpha()));
        }

        @Override
        public String format(Color c, boolean hasAlpha) {
            float[] hsl = Color.RGBtoHSB(c.getRed(), c.getGreen(), c.getBlue(),
                    null);

            return hasAlpha ? formatWithAlpha(c, hsl) : formatWithoutAlpha(hsl);
        }

    };

    private String description;

    private Formatter(String description) {
        this.description = description;
    }

    protected float toHexProportion(int value) {
        return ((float) value) / 255;
    }

    public abstract String format(Color c, boolean hasAlpha);

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
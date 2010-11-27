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

        @Override
        public String format(Color c, boolean hasAlpha) {
            return String.format(RGB_FORMAT, c.getRed(), c.getGreen(),
                    c.getBlue());
        }
    },
    PERCENT("Percent") {
        private final String RGB_FORMAT = "rgb(%3d%%, %3d%%, %3d%%)";
        private final String RGBA_FORMAT = "rgba(%3d%%, %3d%%, %3d%%, %.2f)";

        private float toHexProportion(int value) {
            return ((float) value) / 255;
        }

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
    };

    private String description;

    private Formatter(String description) {
        this.description = description;
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
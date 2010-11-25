/**
 * 
 */
package colorselector;

import java.awt.Color;
import java.awt.Component;

import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.plaf.basic.BasicComboBoxRenderer;

/**
 * @author rafael
 * 
 */
public enum Formatter {

    HEX("Hexadecimal") {
        @Override
        public String format(Color c, boolean hasAlpha) {
            return String.format("#%02x%02x%02x", c.getRed(), c.getGreen(),
                    c.getBlue()).toUpperCase();
        }
    },
    RGB("RGB") {
        @Override
        public String format(Color c, boolean hasAlpha) {
            return String.format("RGB(%03d, %03d, %03d)", c.getRed(),
                    c.getGreen(), c.getBlue());
        }
    },
    PERCENT("Percent") {

        private float toHexPercent(int value) {
            return (float) (100.0 * value / 255);
        }

        private String formatWithAlpha(Color c) {
            float percenteAlpha = (float) c.getAlpha() / 255;

            return String.format("RGB(%3.1f, %3.1f, %3.1f, %.2f)",
                    toHexPercent(c.getRed()), toHexPercent(c.getGreen()),
                    toHexPercent(c.getBlue()), percenteAlpha);
        }

        private String formatWithOutAlpha(Color c) {
            return String.format("RGB(%3.1f, %3.1f, %3.1f)",
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
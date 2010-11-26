/**
 * 
 */
package colorselector;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.Insets;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

import javax.swing.BorderFactory;
import javax.swing.ButtonGroup;
import javax.swing.JCheckBox;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.border.EtchedBorder;

/**
 * @author rafael
 * 
 */
public class ColorSelector {

    private JFrame frmColorSelector = null; // @jve:decl-index=0:visual-constraint="10,10"
    private JPanel jContentPane = null;
    private JMenuBar jJMenuBar = null;
    private JMenu fileMenu = null;
    private JMenu mnuOptions = null;
    private JMenu helpMenu = null;
    private JMenuItem mniExit = null;
    private JMenuItem aboutMenuItem = null;
    private JMenuItem mniRandomColor = null;
    private JDialog aboutDialog = null; // @jve:decl-index=0:visual-constraint="557,34"
    private JPanel aboutContentPane = null;
    private JLabel aboutVersionLabel = null;
    private JPanel pnlColor = null;
    private SliderSpinner slspRed = null;
    private SliderSpinner slspGreen = null;
    private SliderSpinner slspBlue = null;
    private JPanel pnlControls = null;
    private PropertyChangeListener changeListener = new PropertyChangeListener() {
        @Override
        public void propertyChange(PropertyChangeEvent evt) {
            if (evt.getPropertyName().equals(SliderSpinner.PROP_VALUE)) {
                sliderChanged((SliderSpinner) evt.getSource()); // @jve:decl-index=0:
            } else if (evt.getPropertyName()
                    .equals(SliderSpinner.PROP_SELECTED)) {
                sliderSelected((SliderSpinner) evt.getSource()); // @jve:decl-index=0:
            }
        }
    };
    private SliderSpinner slspAlpha = null;
    private JTextField txfColorValue = null;
    private JCheckBox chbEnableAlpha = null;
    private JComboBox cmbFormat = null;
    private JComboBox chbEqualizer = null;
    private JMenu mnuFormat = null;
    private JCheckBoxMenuItem mniEnableAlpha = null;

    private Set<SliderSpinner> syncronizedSliders = new HashSet<SliderSpinner>(); // @jve:decl-index=0:

    private void changeSliderSpinnerValue(SliderSpinner sliderSpinner, int value) {
        sliderSpinner.removePropertyChangeListener(this.changeListener);
        sliderSpinner.setValue(value);
        sliderSpinner.addPropertyChangeListener(this.changeListener);
    }

    private void generateRandomColor() {
        Random random = new Random();
        int max = SliderSpinner.MAX_VALUE + 1;
        int syncronizedValue = random.nextInt(max);

        this.changeSliderSpinnerValue(
                this.getSlspRed(),
                this.syncronizedSliders.contains(this.getSlspRed()) ? syncronizedValue
                        : random.nextInt(max));
        this.changeSliderSpinnerValue(
                this.getSlspGreen(),
                this.syncronizedSliders.contains(this.getSlspGreen()) ? syncronizedValue
                        : random.nextInt(max));
        this.changeSliderSpinnerValue(
                this.getSlspBlue(),
                this.syncronizedSliders.contains(this.getSlspBlue()) ? syncronizedValue
                        : random.nextInt(max));
        this.changeSliderSpinnerValue(
                this.getSlspAlpha(),
                this.syncronizedSliders.contains(this.getSlspAlpha()) ? syncronizedValue
                        : random.nextInt(max));

        this.changeColor();
    }

    private void sliderChanged(SliderSpinner source) {
        if (this.syncronizedSliders.contains(source)) {
            for (SliderSpinner sliderSpinner : this.syncronizedSliders) {
                if (!sliderSpinner.equals(source)) {
                    this.changeSliderSpinnerValue(sliderSpinner,
                            source.getValue());
                }
            }
        }

        this.changeColor();
    }

    private void sliderSelected(SliderSpinner source) {
        if (source.isSelected()) {
            this.syncronizedSliders.add(source);
            System.out.println(this.syncronizedSliders);

            int sum = 0;
            for (SliderSpinner sliderSpinner : this.syncronizedSliders) {
                sum += sliderSpinner.getValue();
            }
            int media = sum / this.syncronizedSliders.size();
            System.out.println(media);

            for (SliderSpinner sliderSpinner : this.syncronizedSliders) {
                this.changeSliderSpinnerValue(sliderSpinner, media);
            }

            this.changeColor();
        } else {
            this.syncronizedSliders.remove(source);
        }
    }

    private void changeColor() {
        Color c = chbEnableAlpha.isSelected() ? //
        new Color(this.getSlspRed().getValue(), //
                this.getSlspGreen().getValue(), //
                this.getSlspBlue().getValue(), //
                this.getSlspAlpha().getValue())
                : //
                new Color(this.getSlspRed().getValue(), //
                        this.getSlspGreen().getValue(), //
                        this.getSlspBlue().getValue());

        this.getPnlColor().setBackground(c);
        this.getTxfColorValue().setText(
                (((Formatter) this.getCmbFormat().getSelectedItem()).format(c,
                        this.chbEnableAlpha.isSelected())));

    }

    private void enableAlpha(boolean enable, Object source) {
        this.slspAlpha.setEnabled(enable);

        if (source == chbEnableAlpha) {
            mniEnableAlpha.setSelected(enable);
        } else {
            chbEnableAlpha.setSelected(enable);
        }

        this.changeColor();
    }

    private void formaterChosen(Formatter formatter, Object source) {
        if (source == this.cmbFormat) {
            for (Component component : this.getMnuFormat().getMenuComponents()) {
                JRadioButtonMenuItem jRadioButtonMenuItem = (JRadioButtonMenuItem) component;
                if (jRadioButtonMenuItem.getText().equals(
                        formatter.getDescription())) {
                    jRadioButtonMenuItem.setSelected(true);
                    break;
                }
            }
        } else {
            this.cmbFormat.setSelectedItem(formatter);
        }

        this.changeColor();
    }

    /**
     * This method initializes frmColorSelector
     * 
     * @return javax.swing.JFrame
     */
    private JFrame getFrmColorSelector() {
        if (frmColorSelector == null) {
            frmColorSelector = new JFrame();
            frmColorSelector.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frmColorSelector.setJMenuBar(getJJMenuBar());
            frmColorSelector.setSize(543, 341);
            frmColorSelector.setContentPane(getJContentPane());
            frmColorSelector.setTitle("Color Selector");
        }
        return frmColorSelector;
    }

    /**
     * This method initializes jContentPane
     * 
     * @return javax.swing.JPanel
     */
    private JPanel getJContentPane() {
        if (jContentPane == null) {
            GridLayout gridLayout = new GridLayout();
            gridLayout.setRows(2);
            gridLayout.setColumns(1);
            GridBagConstraints gridBagConstraints = new GridBagConstraints();
            gridBagConstraints.gridx = 0;
            gridBagConstraints.gridy = 0;
            jContentPane = new JPanel();
            jContentPane.setLayout(gridLayout);
            jContentPane.add(getPnlColor(), null);
            jContentPane.add(getPnlControls(), null);
        }
        return jContentPane;
    }

    /**
     * This method initializes jJMenuBar
     * 
     * @return javax.swing.JMenuBar
     */
    private JMenuBar getJJMenuBar() {
        if (jJMenuBar == null) {
            jJMenuBar = new JMenuBar();
            jJMenuBar.add(getFileMenu());
            jJMenuBar.add(getMnuOptions());
            jJMenuBar.add(getHelpMenu());
        }
        return jJMenuBar;
    }

    /**
     * This method initializes jMenu
     * 
     * @return javax.swing.JMenu
     */
    private JMenu getFileMenu() {
        if (fileMenu == null) {
            fileMenu = new JMenu();
            fileMenu.setText("File");
            fileMenu.add(getMniRandomColor());
            fileMenu.add(getMniExit());
        }
        return fileMenu;
    }

    /**
     * This method initializes jMenu
     * 
     * @return javax.swing.JMenu
     */
    private JMenu getMnuOptions() {
        if (mnuOptions == null) {
            mnuOptions = new JMenu();
            mnuOptions.setText("Options");
            mnuOptions.add(getMnuFormat());
            mnuOptions.add(getMniEnableAlpha());
        }
        return mnuOptions;
    }

    /**
     * This method initializes jMenu
     * 
     * @return javax.swing.JMenu
     */
    private JMenu getHelpMenu() {
        if (helpMenu == null) {
            helpMenu = new JMenu();
            helpMenu.setText("Help");
            helpMenu.add(getAboutMenuItem());
        }
        return helpMenu;
    }

    /**
     * This method initializes jMenuItem
     * 
     * @return javax.swing.JMenuItem
     */
    private JMenuItem getMniExit() {
        if (mniExit == null) {
            mniExit = new JMenuItem();
            mniExit.setText("Exit");
            mniExit.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    System.exit(0);
                }
            });
        }
        return mniExit;
    }

    /**
     * This method initializes jMenuItem
     * 
     * @return javax.swing.JMenuItem
     */
    private JMenuItem getAboutMenuItem() {
        if (aboutMenuItem == null) {
            aboutMenuItem = new JMenuItem();
            aboutMenuItem.setText("About");
            aboutMenuItem.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    JDialog aboutDialog = getAboutDialog();
                    aboutDialog.pack();
                    Point loc = getFrmColorSelector().getLocation();
                    loc.translate(20, 20);
                    aboutDialog.setLocation(loc);
                    aboutDialog.setVisible(true);
                }
            });
        }
        return aboutMenuItem;
    }

    /**
     * This method initializes aboutDialog
     * 
     * @return javax.swing.JDialog
     */
    private JDialog getAboutDialog() {
        if (aboutDialog == null) {
            aboutDialog = new JDialog(getFrmColorSelector(), true);
            aboutDialog.setTitle("About");
            aboutDialog.setContentPane(getAboutContentPane());
        }
        return aboutDialog;
    }

    /**
     * This method initializes aboutContentPane
     * 
     * @return javax.swing.JPanel
     */
    private JPanel getAboutContentPane() {
        if (aboutContentPane == null) {
            aboutContentPane = new JPanel();
            aboutContentPane.setLayout(new BorderLayout());
            aboutContentPane.add(getAboutVersionLabel(), BorderLayout.CENTER);
        }
        return aboutContentPane;
    }

    /**
     * This method initializes aboutVersionLabel
     * 
     * @return javax.swing.JLabel
     */
    private JLabel getAboutVersionLabel() {
        if (aboutVersionLabel == null) {
            aboutVersionLabel = new JLabel();
            aboutVersionLabel.setText("Version 1.0");
            aboutVersionLabel.setHorizontalAlignment(SwingConstants.CENTER);
        }
        return aboutVersionLabel;
    }

    /**
     * This method initializes jMenuItem
     * 
     * @return javax.swing.JMenuItem
     */
    private JMenuItem getMniRandomColor() {
        if (mniRandomColor == null) {
            mniRandomColor = new JMenuItem();
            mniRandomColor.setText("Random Color");
            mniRandomColor
                    .addActionListener(new java.awt.event.ActionListener() {
                        public void actionPerformed(java.awt.event.ActionEvent e) {
                            generateRandomColor();
                        }
                    });

        }
        return mniRandomColor;
    }

    /**
     * This method initializes pnlColor
     * 
     * @return javax.swing.JPanel
     */
    private JPanel getPnlColor() {
        if (pnlColor == null) {
            FlowLayout flowLayout = new FlowLayout();
            flowLayout.setAlignment(FlowLayout.RIGHT);
            pnlColor = new JPanel();
            pnlColor.setBorder(BorderFactory
                    .createEtchedBorder(EtchedBorder.LOWERED));
            pnlColor.setLayout(flowLayout);
            pnlColor.addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseClicked(java.awt.event.MouseEvent e) {
                    if (e.getClickCount() == 2) {
                        ColorSelector.this.generateRandomColor();
                    }
                }
            });
        }
        return pnlColor;
    }

    /**
     * This method initializes slspRed
     * 
     * @return colorselector.SliderSpinner
     */
    private SliderSpinner getSlspRed() {
        if (slspRed == null) {
            slspRed = new SliderSpinner();
            slspRed.setTitle("R");
            slspRed.addPropertyChangeListener(this.changeListener);
        }
        return slspRed;
    }

    /**
     * This method initializes slspGreen
     * 
     * @return colorselector.SliderSpinner
     */
    private SliderSpinner getSlspGreen() {
        if (slspGreen == null) {
            GridBagConstraints gridBagConstraints3 = new GridBagConstraints();
            gridBagConstraints3.fill = GridBagConstraints.HORIZONTAL;
            gridBagConstraints3.gridx = 0;
            gridBagConstraints3.gridy = 2;
            gridBagConstraints3.ipadx = 0;
            gridBagConstraints3.ipady = 2;
            gridBagConstraints3.weightx = 1.0;
            gridBagConstraints3.insets = new Insets(5, 5, 5, 5);
            slspGreen = new SliderSpinner();
            slspGreen.setTitle("G");
            slspGreen.addPropertyChangeListener(this.changeListener);
        }
        return slspGreen;
    }

    /**
     * This method initializes slspBlue
     * 
     * @return colorselector.SliderSpinner
     */
    private SliderSpinner getSlspBlue() {
        if (slspBlue == null) {
            slspBlue = new SliderSpinner();
            slspBlue.setTitle("B");
            slspBlue.addPropertyChangeListener(this.changeListener);
        }
        return slspBlue;
    }

    /**
     * This method initializes pnlControls
     * 
     * @return javax.swing.JPanel
     */
    private JPanel getPnlControls() {
        if (pnlControls == null) {
            GridBagConstraints gridBagChbEqualizer = new GridBagConstraints();
            gridBagChbEqualizer.fill = GridBagConstraints.NONE;
            gridBagChbEqualizer.gridy = 0;
            gridBagChbEqualizer.weightx = 1.0;
            gridBagChbEqualizer.anchor = GridBagConstraints.WEST;
            gridBagChbEqualizer.insets = new Insets(5, 5, 5, 5);
            gridBagChbEqualizer.gridx = 1;

            GridBagConstraints gridBagCmbFormat = new GridBagConstraints();
            gridBagCmbFormat.fill = GridBagConstraints.NONE;
            gridBagCmbFormat.gridy = 2;
            gridBagCmbFormat.weightx = 1.0;
            gridBagCmbFormat.insets = new Insets(5, 5, 5, 5);
            gridBagCmbFormat.anchor = GridBagConstraints.WEST;
            gridBagCmbFormat.gridx = 1;

            GridBagConstraints gridBagSlspBlue = new GridBagConstraints();
            gridBagSlspBlue.gridx = 0;
            gridBagSlspBlue.fill = GridBagConstraints.HORIZONTAL;
            gridBagSlspBlue.insets = new Insets(5, 5, 5, 5);
            gridBagSlspBlue.weightx = 4.0;
            gridBagSlspBlue.gridy = 2;
            GridBagConstraints gridBagEnableAlpha = new GridBagConstraints();
            gridBagEnableAlpha.insets = new Insets(5, 5, 5, 5);
            gridBagEnableAlpha.gridy = 3;
            gridBagEnableAlpha.ipadx = 0;
            gridBagEnableAlpha.ipady = 0;
            gridBagEnableAlpha.anchor = GridBagConstraints.WEST;
            gridBagEnableAlpha.gridx = 1;
            GridBagConstraints gridBagTxfColorValue = new GridBagConstraints();
            gridBagTxfColorValue.fill = GridBagConstraints.HORIZONTAL;
            gridBagTxfColorValue.gridx = 1;
            gridBagTxfColorValue.gridy = 1;
            gridBagTxfColorValue.ipadx = 0;
            gridBagTxfColorValue.ipady = 0;
            gridBagTxfColorValue.weightx = 1.0;
            gridBagTxfColorValue.anchor = GridBagConstraints.WEST;
            gridBagTxfColorValue.insets = new Insets(5, 5, 5, 5);
            GridBagConstraints gridBagSlspAlpha = new GridBagConstraints();
            gridBagSlspAlpha.insets = new Insets(5, 5, 5, 5);
            gridBagSlspAlpha.gridy = 3;
            gridBagSlspAlpha.ipadx = 0;
            gridBagSlspAlpha.ipady = 0;
            gridBagSlspAlpha.fill = GridBagConstraints.HORIZONTAL;
            gridBagSlspAlpha.weightx = 4.0;
            gridBagSlspAlpha.weighty = 0.0;
            gridBagSlspAlpha.gridx = 0;
            GridBagConstraints gridBagSlspGreen = new GridBagConstraints();
            gridBagSlspGreen.insets = new Insets(5, 5, 5, 5);
            gridBagSlspGreen.gridy = 1;
            gridBagSlspGreen.ipadx = 0;
            gridBagSlspGreen.ipady = 0;
            gridBagSlspGreen.fill = GridBagConstraints.HORIZONTAL;
            gridBagSlspGreen.weightx = 4.0;
            gridBagSlspGreen.gridx = 0;
            GridBagConstraints gridBagSlspRed = new GridBagConstraints();
            gridBagSlspRed.insets = new Insets(5, 5, 5, 5);
            gridBagSlspRed.gridy = 0;
            gridBagSlspRed.ipadx = 0;
            gridBagSlspRed.ipady = 0;
            gridBagSlspRed.fill = GridBagConstraints.HORIZONTAL;
            gridBagSlspRed.weightx = 4.0;
            gridBagSlspRed.weighty = 0.0;
            gridBagSlspRed.gridx = 0;

            pnlControls = new JPanel();
            pnlControls.setLayout(new GridBagLayout());
            pnlControls.add(getSlspRed(), gridBagSlspRed);
            pnlControls.add(getSlspGreen(), gridBagSlspGreen);
            pnlControls.add(getSlspBlue(), gridBagSlspBlue);
            pnlControls.add(getSlspAlpha(), gridBagSlspAlpha);
            pnlControls.add(getTxfColorValue(), gridBagTxfColorValue);
            pnlControls.add(getCmbFormat(), gridBagCmbFormat);
            pnlControls.add(getChbEnableAlpha(), gridBagEnableAlpha);
            pnlControls.add(getChbEqualizer(), gridBagChbEqualizer);
        }
        return pnlControls;
    }

    /**
     * This method initializes slspAlpha
     * 
     * @return colorselector.SliderSpinner
     */
    private SliderSpinner getSlspAlpha() {
        if (slspAlpha == null) {
            slspAlpha = new SliderSpinner();
            slspAlpha.setTitle("A");
            slspAlpha.addPropertyChangeListener(this.changeListener);
            slspAlpha.setEnabled(false);
        }
        return slspAlpha;
    }

    /**
     * This method initializes txfColorValue
     * 
     * @return javax.swing.JTextField
     */
    private JTextField getTxfColorValue() {
        if (txfColorValue == null) {
            txfColorValue = new JTextField();
            txfColorValue.setPreferredSize(new Dimension(100, 20));
            txfColorValue.setMinimumSize(new Dimension(100, 20));
            txfColorValue.setFont(new Font("Monospaced", Font.PLAIN, 12));
            txfColorValue.setEditable(false);
        }
        return txfColorValue;
    }

    /**
     * This method initializes chbEnableAlpha
     * 
     * @return javax.swing.JCheckBox
     */
    private JCheckBox getChbEnableAlpha() {
        if (chbEnableAlpha == null) {
            chbEnableAlpha = new JCheckBox();
            chbEnableAlpha.setText("Enable Alpha");
            chbEnableAlpha
                    .addChangeListener(new javax.swing.event.ChangeListener() {
                        public void stateChanged(javax.swing.event.ChangeEvent e) {
                            enableAlpha(chbEnableAlpha.isSelected(),
                                    e.getSource());
                        }
                    });
        }
        return chbEnableAlpha;
    }

    /**
     * This method initializes cmbFormat
     * 
     * @return javax.swing.JComboBox
     */
    private JComboBox getCmbFormat() {
        if (cmbFormat == null) {
            cmbFormat = new JComboBox(Formatter.values());
            cmbFormat.setRenderer(new FormatterRenderer());
            cmbFormat.addItemListener(new java.awt.event.ItemListener() {
                public void itemStateChanged(java.awt.event.ItemEvent e) {
                    formaterChosen((Formatter) e.getItem(), e.getSource());
                }
            });
        }
        return cmbFormat;
    }

    /**
     * This method initializes chbEqualizer
     * 
     * @return javax.swing.JComboBox
     */
    private JComboBox getChbEqualizer() {
        if (chbEqualizer == null) {
            chbEqualizer = new JComboBox(new Object[] { "ONE" });
        }
        return chbEqualizer;
    }

    /**
     * This method initializes mnuFormat
     * 
     * @return javax.swing.JMenu
     */
    private JMenu getMnuFormat() {
        if (mnuFormat == null) {
            mnuFormat = new JMenu();
            mnuFormat.setText("Color Format");

            // Formats
            ButtonGroup group = new ButtonGroup();
            for (final Formatter formatter : Formatter.values()) {
                final JRadioButtonMenuItem mniFormat = new JRadioButtonMenuItem(
                        formatter.getDescription());
                group.add(mniFormat);
                mniFormat.addActionListener(new ActionListener() {
                    @Override
                    public void actionPerformed(ActionEvent event) {
                        formaterChosen(formatter, mniFormat);
                    }
                });

                mnuFormat.add(mniFormat);
            }
        }
        return mnuFormat;
    }

    /**
     * This method initializes mniEnableAlpha
     * 
     * @return javax.swing.JCheckBoxMenuItem
     */
    private JCheckBoxMenuItem getMniEnableAlpha() {
        if (mniEnableAlpha == null) {
            mniEnableAlpha = new JCheckBoxMenuItem("Enable Alpha");
            mniEnableAlpha.addItemListener(new java.awt.event.ItemListener() {
                public void itemStateChanged(java.awt.event.ItemEvent e) {
                    enableAlpha(mniEnableAlpha.isSelected(), e.getSource());
                }
            });
        }
        return mniEnableAlpha;
    }

    /**
     * Launches this application
     */
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                ColorSelector application = new ColorSelector();
                application.getFrmColorSelector().setVisible(true);
                application.getSlspRed().setValue(SliderSpinner.MAX_VALUE);
                application.getSlspGreen().setValue(SliderSpinner.MAX_VALUE);
                application.getSlspBlue().setValue(SliderSpinner.MAX_VALUE);
                application.getSlspAlpha().setValue(SliderSpinner.MIN_VALUE);
            }
        });
    }

}
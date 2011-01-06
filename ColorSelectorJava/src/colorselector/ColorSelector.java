/**
 * 
 */
package colorselector;

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
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

import javax.swing.BorderFactory;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JComboBox;
import javax.swing.JComponent;
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
    private JDialog aboutDialog = null;  //  @jve:decl-index=0:visual-constraint="846,10"
    private JPanel aboutContentPane = null;
    private JLabel lblProgramVersion = null;
    private JPanel pnlColor = null;
    private SliderSpinner slspRed = null;
    private SliderSpinner slspGreen = null;
    private SliderSpinner slspBlue = null;
    private JPanel pnlControls = null;

    private PropertyChangeListener sliderListener = new PropertyChangeListener() {
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
    private PropertyChangeListener sliderColorListener = new PropertyChangeListener() {
        @Override
        public void propertyChange(PropertyChangeEvent evt) {
            if (evt.getPropertyName().equals(SliderSpinner.PROP_VALUE)) {
                changeSliderColor((SliderSpinner) evt.getSource());  //  @jve:decl-index=0:
            }
        }
    };

    private ItemListener webColorListener = new ItemListener() {
        @Override
        public void itemStateChanged(ItemEvent e) {
            webColorSelected();

        }
    };

    private SliderSpinner slspAlpha = null;
    private JTextField txfColorValue = null;
    private JCheckBox chbEnableAlpha = null;
    private JComboBox cmbFormat = null;
    private JComboBox cmbWebColors = null;
    private JMenu mnuFormat = null;
    private JCheckBoxMenuItem mniEnableAlpha = null;

    private Set<SliderSpinner> syncronizedSliders = new HashSet<SliderSpinner>(); // @jve:decl-index=0:
    private JLabel lblTitleColorCode = null;
    private JLabel lblTitleWebColor = null;
    private JLabel lblTitleColorFormat = null;
    private JLabel lblProgramName = null;
    private JLabel lblProgramCopyright = null;
    private JButton btnAboutOk = null;

    private void changeSliderSpinnerValue(SliderSpinner sliderSpinner, int value) {
        sliderSpinner.removePropertyChangeListener(this.sliderListener);
        sliderSpinner.setValue(value);
        sliderSpinner.addPropertyChangeListener(this.sliderListener);
    }

    private void changeSliderColor(SliderSpinner source) {
        if(source == this.getSlspRed()) {
            source.setBackground(new Color(source.getValue(), 0, 0));
        } else if(source == this.getSlspGreen()) {
            source.setBackground(new Color(0, source.getValue(), 0));
        } if(source == this.getSlspBlue()) {
            source.setBackground(new Color(0, 0, source.getValue()));
        } 
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

        this.changeColor(this.getPnlColor());
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
        
        this.changeColor(source);
    }

    private void sliderSelected(SliderSpinner source) {
        if (source.isSelected()) {
            this.syncronizedSliders.add(source);

            int sum = 0;
            for (SliderSpinner sliderSpinner : this.syncronizedSliders) {
                sum += sliderSpinner.getValue();
            }
            int media = sum / this.syncronizedSliders.size();

            for (SliderSpinner sliderSpinner : this.syncronizedSliders) {
                this.changeSliderSpinnerValue(sliderSpinner, media);
            }

            this.changeColor(source);
        } else {
            this.syncronizedSliders.remove(source);
        }
    }

    private void webColorSelected() {
        WebColor webColor = (WebColor) this.getCmbWebColors().getSelectedItem();

        if (webColor != WebColor.UNDEFINED) {
            this.changeSliderSpinnerValue(this.getSlspRed(), webColor.getRed());
            this.changeSliderSpinnerValue(this.getSlspGreen(),
                    webColor.getGreen());
            this.changeSliderSpinnerValue(this.getSlspBlue(),
                    webColor.getBlue());

            this.changeColor(this.getCmbWebColors());
        }
    }

    private void changeColor(JComponent source) {
        Color simpleColor = new Color(this.getSlspRed().getValue(), //
                this.getSlspGreen().getValue(), //
                this.getSlspBlue().getValue(), //
                this.getSlspAlpha().getValue());
        Color alphaColor = new Color(this.getSlspRed().getValue(), //
                this.getSlspGreen().getValue(), //
                this.getSlspBlue().getValue());
        Color c = chbEnableAlpha.isSelected() ? simpleColor : alphaColor;

        this.getPnlColor().setBackground(c);
        this.showColorCode();
        if (source != this.getCmbWebColors()) {
            changeCmbWebColors(c);
        }
    }

    private void showColorCode() {
        Formatter formatter = (Formatter) this.getCmbFormat().getSelectedItem();
        String colorCode = formatter.format(this.getPnlColor().getBackground(),
                this.chbEnableAlpha.isSelected());
        this.getTxfColorValue().setText(colorCode);
    }

    private void changeCmbWebColors(Color c) {
        WebColor selected = WebColor.UNDEFINED;

        for (WebColor webColor : WebColor.values()) {
            if ((c.getRed() == webColor.getRed())
                    && (c.getGreen() == webColor.getGreen())
                    && (c.getBlue() == webColor.getBlue())) {
                selected = webColor;
                break;
            }
        }

        this.getCmbWebColors().removeItemListener(webColorListener);
        this.getCmbWebColors().setSelectedItem(selected);
        this.getCmbWebColors().addItemListener(webColorListener);
    }

    private void enableAlpha(boolean enable, JComponent source) {
        this.slspAlpha.setEnabled(enable);

        if (source == chbEnableAlpha) {
            mniEnableAlpha.setSelected(enable);
        } else {
            chbEnableAlpha.setSelected(enable);
        }

        this.changeColor(source);
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

        this.showColorCode();
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
            frmColorSelector.setPreferredSize(new Dimension(800, 600));
            frmColorSelector.setMinimumSize(new Dimension(200, 150));
            frmColorSelector.setJMenuBar(getJJMenuBar());
            frmColorSelector.setSize(792, 341);
            frmColorSelector.setContentPane(getJContentPane());
            frmColorSelector.setTitle(Messages.getString("ColorSelector.title")); //$NON-NLS-1$
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
            fileMenu.setText(Messages.getString("ColorSelector.menu.file")); //$NON-NLS-1$
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
            mnuOptions.setText(Messages.getString("ColorSelector.menu.options")); //$NON-NLS-1$
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
            helpMenu.setText(Messages.getString("ColorSelector.menu.help")); //$NON-NLS-1$
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
            mniExit.setText(Messages.getString("ColorSelector.menu.exit")); //$NON-NLS-1$
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
            aboutMenuItem.setText(Messages.getString("ColorSelector.menu.about")); //$NON-NLS-1$
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
            aboutDialog.setTitle(Messages.getString("ColorSelector.aboutDialog.title")); //$NON-NLS-1$
            aboutDialog.setSize(new Dimension(161, 128));
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
            GridBagConstraints gridBagBtnAboutOk = new GridBagConstraints();
            gridBagBtnAboutOk.gridx = 0;
            gridBagBtnAboutOk.insets = new Insets(5, 5, 5, 5);
            gridBagBtnAboutOk.gridy = 3;
            
            GridBagConstraints gridBagLblProgramCopyright = new GridBagConstraints();
            gridBagLblProgramCopyright.gridx = 0;
            gridBagLblProgramCopyright.fill = GridBagConstraints.HORIZONTAL;
            gridBagLblProgramCopyright.insets = new Insets(1, 5, 1, 5);
            gridBagLblProgramCopyright.gridy = 2;
            
            lblProgramCopyright = new JLabel();
            lblProgramCopyright.setText(Messages.getString("ColorSelector.aboutDialog.copyright")); //$NON-NLS-1$
            lblProgramCopyright.setDisplayedMnemonic(KeyEvent.VK_UNDEFINED);
            lblProgramCopyright.setHorizontalAlignment(SwingConstants.CENTER);
            
            GridBagConstraints gridBagLblProgramName = new GridBagConstraints();
            gridBagLblProgramName.gridx = 0;
            gridBagLblProgramName.fill = GridBagConstraints.HORIZONTAL;
            gridBagLblProgramName.insets = new Insets(1, 5, 1, 5);
            gridBagLblProgramName.gridy = 0;
            
            lblProgramName = new JLabel();
            lblProgramName.setText(Messages.getString("ColorSelector.aboutDialog.name")); //$NON-NLS-1$
            lblProgramName.setHorizontalAlignment(SwingConstants.CENTER);
            
            GridBagConstraints gridBagLblProgramVersion = new GridBagConstraints();
            gridBagLblProgramVersion.gridx = 0;
            gridBagLblProgramVersion.fill = GridBagConstraints.HORIZONTAL;
            gridBagLblProgramVersion.insets = new Insets(1, 5, 1, 5);
            gridBagLblProgramVersion.gridy = 1;
            
            aboutContentPane = new JPanel();
            aboutContentPane.setLayout(new GridBagLayout());
            aboutContentPane.add(getLblProgramVersion(), gridBagLblProgramVersion);
            aboutContentPane.add(lblProgramName, gridBagLblProgramName);
            aboutContentPane.add(lblProgramCopyright, gridBagLblProgramCopyright);
            aboutContentPane.add(getBtnAboutOk(), gridBagBtnAboutOk);
        }
        return aboutContentPane;
    }

    /**
     * This method initializes lblProgramVersion
     * 
     * @return javax.swing.JLabel
     */
    private JLabel getLblProgramVersion() {
        if (lblProgramVersion == null) {
            lblProgramVersion = new JLabel();
            lblProgramVersion.setText(Messages.getString("ColorSelector.aboutDialog.version")); //$NON-NLS-1$
            lblProgramVersion.setHorizontalAlignment(SwingConstants.CENTER);
        }
        return lblProgramVersion;
    }

    /**
     * This method initializes jMenuItem
     * 
     * @return javax.swing.JMenuItem
     */
    private JMenuItem getMniRandomColor() {
        if (mniRandomColor == null) {
            mniRandomColor = new JMenuItem();
            mniRandomColor.setText(Messages.getString("ColorSelector.menu.random_color")); //$NON-NLS-1$
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
            slspRed.setTitle(Messages.getString("ColorSelector.sliderspinner.r.title")); //$NON-NLS-1$
            slspRed.addPropertyChangeListener(this.sliderListener);
            slspRed.addPropertyChangeListener(this.sliderColorListener);
            slspRed.setContrastTitleFont(true);
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
            slspGreen = new SliderSpinner();
            slspGreen.setTitle(Messages.getString("ColorSelector.sliderapinner.g.title")); //$NON-NLS-1$
            slspGreen.addPropertyChangeListener(this.sliderListener);
            slspGreen.addPropertyChangeListener(this.sliderColorListener);
            slspGreen.setContrastTitleFont(true);
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
            slspBlue.setTitle(Messages.getString("ColorSelector.sliderapinner.b.title")); //$NON-NLS-1$
            slspBlue.addPropertyChangeListener(this.sliderListener);
            slspBlue.addPropertyChangeListener(this.sliderColorListener);
            slspBlue.setContrastTitleFont(true);
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
            GridBagConstraints gridBagLblTitleColorFormat = new GridBagConstraints();
            gridBagLblTitleColorFormat.gridx = 1;
            gridBagLblTitleColorFormat.anchor = GridBagConstraints.EAST;
            gridBagLblTitleColorFormat.insets = new Insets(5, 10, 5, 5);
            gridBagLblTitleColorFormat.gridy = 2;
            lblTitleColorFormat = new JLabel();
            lblTitleColorFormat.setText(Messages.getString("ColorSelector.title.colorformat")); //$NON-NLS-1$
            
            GridBagConstraints gridBagLblTitleWebColor = new GridBagConstraints();
            gridBagLblTitleWebColor.gridx = 1;
            gridBagLblTitleWebColor.anchor = GridBagConstraints.EAST;
            gridBagLblTitleWebColor.insets = new Insets(5, 10, 5, 5);
            gridBagLblTitleWebColor.gridy = 0;
            lblTitleWebColor = new JLabel();
            lblTitleWebColor.setText(Messages.getString("ColorSelector.title.webcolor")); //$NON-NLS-1$

            GridBagConstraints gridBagLblTitleColorCode = new GridBagConstraints();
            gridBagLblTitleColorCode.gridx = 1;
            gridBagLblTitleColorCode.anchor = GridBagConstraints.EAST;
            gridBagLblTitleColorCode.insets = new Insets(5, 10, 5, 5);
            gridBagLblTitleColorCode.gridy = 1;
            lblTitleColorCode = new JLabel();
            lblTitleColorCode.setText(Messages.getString("ColorSelector.title.colorcode")); //$NON-NLS-1$
            
            GridBagConstraints gridBagCmbWebColors = new GridBagConstraints();
            gridBagCmbWebColors.fill = GridBagConstraints.NONE;
            gridBagCmbWebColors.gridy = 0;
            gridBagCmbWebColors.weightx = 1.0;
            gridBagCmbWebColors.anchor = GridBagConstraints.WEST;
            gridBagCmbWebColors.insets = new Insets(5, 5, 5, 5);
            gridBagCmbWebColors.gridx = 2;

            GridBagConstraints gridBagCmbFormat = new GridBagConstraints();
            gridBagCmbFormat.fill = GridBagConstraints.NONE;
            gridBagCmbFormat.gridy = 2;
            gridBagCmbFormat.weightx = 1.0;
            gridBagCmbFormat.insets = new Insets(5, 5, 5, 5);
            gridBagCmbFormat.anchor = GridBagConstraints.WEST;
            gridBagCmbFormat.gridx = 2;

            GridBagConstraints gridBagSlspBlue = new GridBagConstraints();
            gridBagSlspBlue.gridx = 0;
            gridBagSlspBlue.fill = GridBagConstraints.HORIZONTAL;
            gridBagSlspBlue.insets = new Insets(5, 5, 5, 5);
            gridBagSlspBlue.weightx = 4.0;
            gridBagSlspBlue.gridy = 2;

            GridBagConstraints gridBagEnableAlpha = new GridBagConstraints();
            gridBagEnableAlpha.insets = new Insets(5, 10, 5, 5);
            gridBagEnableAlpha.gridy = 3;
            gridBagEnableAlpha.ipadx = 0;
            gridBagEnableAlpha.ipady = 0;
            gridBagEnableAlpha.anchor = GridBagConstraints.WEST;
            gridBagEnableAlpha.gridwidth = 2;
            gridBagEnableAlpha.fill = GridBagConstraints.HORIZONTAL;
            gridBagEnableAlpha.gridx = 1;

            GridBagConstraints gridBagTxfColorValue = new GridBagConstraints();
            gridBagTxfColorValue.fill = GridBagConstraints.HORIZONTAL;
            gridBagTxfColorValue.gridx = 2;
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
            pnlControls.add(getCmbWebColors(), gridBagCmbWebColors);
            pnlControls.add(lblTitleWebColor, gridBagLblTitleWebColor);
            pnlControls.add(lblTitleColorCode, gridBagLblTitleColorCode);
            pnlControls.add(lblTitleColorFormat, gridBagLblTitleColorFormat);
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
            slspAlpha.setTitle(Messages.getString("ColorSelector.sliderapinner.a.title")); //$NON-NLS-1$
            slspAlpha.addPropertyChangeListener(this.sliderListener);
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
            chbEnableAlpha.setText(Messages.getString("ColorSelector.title.enablealpha")); //$NON-NLS-1$
            chbEnableAlpha.addItemListener(new java.awt.event.ItemListener() {
                public void itemStateChanged(java.awt.event.ItemEvent e) {
                    enableAlpha(chbEnableAlpha.isSelected(),
                            chbEnableAlpha);
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
     * This method initializes cmbWebColors
     * 
     * @return javax.swing.JComboBox
     */
    private JComboBox getCmbWebColors() {
        if (cmbWebColors == null) {
            cmbWebColors = new JComboBox(WebColor.values());
            cmbWebColors.setRenderer(new ColorEnumRenderer());
            cmbWebColors.addItemListener(webColorListener);
        }
        return cmbWebColors;
    }

    /**
     * This method initializes mnuFormat
     * 
     * @return javax.swing.JMenu
     */
    private JMenu getMnuFormat() {
        if (mnuFormat == null) {
            mnuFormat = new JMenu();
            mnuFormat.setText(Messages.getString("ColorSelector.menu.colorformat")); //$NON-NLS-1$

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
            mniEnableAlpha = new JCheckBoxMenuItem(Messages.getString("ColorSelector.menu.enablealpha")); //$NON-NLS-1$
            mniEnableAlpha.addItemListener(new java.awt.event.ItemListener() {
                public void itemStateChanged(java.awt.event.ItemEvent e) {
                    enableAlpha(mniEnableAlpha.isSelected(), mniEnableAlpha);
                }
            });
        }
        return mniEnableAlpha;
    }

    /**
     * This method initializes btnAboutOk	
     * 	
     * @return javax.swing.JButton	
     */
    private JButton getBtnAboutOk() {
        if (btnAboutOk == null) {
            btnAboutOk = new JButton();
            btnAboutOk.setText("OK");
            btnAboutOk.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent e) {
                    aboutDialog.setVisible(false);
                    aboutDialog.dispose();
                }
            });
        }
        return btnAboutOk;
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
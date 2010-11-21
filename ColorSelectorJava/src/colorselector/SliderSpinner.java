/**
 * 
 */
package colorselector;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.JSpinner;
import javax.swing.JSpinner.NumberEditor;
import javax.swing.SpinnerNumberModel;

/**
 * @author rafael
 * 
 */
public class SliderSpinner extends JPanel {

	private static final long serialVersionUID = 1545098305938L;
	private JLabel lblTitle = null;
	private JSlider sldValue = null;
	private JSpinner spnValue = null;
	private int value = 0;

	public static int MIN_VALUE = 0;
	public static int MAX_VALUE = 255;

	public static final String PROP_VALUE = "value";

	/**
	 * This is the default constructor
	 */
	public SliderSpinner() {
		super();
		initialize();
		this.setValue(MIN_VALUE);
	}

	private void incrementValue(boolean addValue, boolean control) {
		if ((addValue && (this.getValue() == MAX_VALUE))
				|| (!addValue && (this.getValue() == MIN_VALUE))) {
			return;
		}

		int delta = (addValue ? +1 : -1) * (control ? 10 : 1);
		int newValue = this.getValue() + delta;
		if (newValue < MIN_VALUE) {
			newValue = MIN_VALUE;
		} else if (newValue > MAX_VALUE) {
			newValue = MAX_VALUE;
		}

		this.changeValue(newValue, null);
	}

	private void changeValue(int newValue, Object source) {
		int oldValue = this.value;
		this.value = newValue;

		if ((source == null) || (source == this.sldValue)) {
			this.spnValue.setValue(this.value);
		}
		if ((source == null) || (source == this.spnValue)) {
			this.sldValue.setValue(this.value);
		}

		super.firePropertyChange(PROP_VALUE, oldValue, newValue);
	}

	/**
	 * This method initializes this
	 * 
	 * @return void
	 */
	private void initialize() {
		GridBagConstraints gridBagConstraints2 = new GridBagConstraints();
		gridBagConstraints2.gridx = 2;
		gridBagConstraints2.ipady = 0;
		gridBagConstraints2.gridy = 0;

		GridBagConstraints gridBagConstraints1 = new GridBagConstraints();
		gridBagConstraints1.fill = GridBagConstraints.HORIZONTAL;
		gridBagConstraints1.gridy = 0;
		gridBagConstraints1.ipadx = 0;
		gridBagConstraints1.ipady = 0;
		gridBagConstraints1.weightx = 1.0;
		gridBagConstraints1.gridx = 1;

		GridBagConstraints gridBagConstraints = new GridBagConstraints();
		gridBagConstraints.gridx = 0;
		gridBagConstraints.ipady = 0;
		gridBagConstraints.gridy = 0;

		lblTitle = new JLabel();
		lblTitle.setText("000");
		this.setSize(300, 53);
		this.setLayout(new GridBagLayout());
		this.add(lblTitle, gridBagConstraints);
		this.add(getSldValue(), gridBagConstraints1);
		this.add(getSpnValue(), gridBagConstraints2);

		this.addMouseWheelListener(new MouseWheelListener() {

			@Override
			public void mouseWheelMoved(MouseWheelEvent e) {
				SliderSpinner.this.incrementValue(
						(e.getWheelRotation() < 0),
						(e.isControlDown() || e.getModifiersEx() == (MouseEvent.META_MASK | MouseWheelEvent.BUTTON3)));

			}
		});
	}

	/**
	 * This method initializes sldValue
	 * 
	 * @return javax.swing.JSlider
	 */
	private JSlider getSldValue() {
		if (sldValue == null) {
			sldValue = new JSlider();
			sldValue.setMaximum(255);
			sldValue.setMajorTickSpacing(50);
			sldValue.setPaintTicks(true);
			sldValue.setMinorTickSpacing(10);
			sldValue.addChangeListener(new javax.swing.event.ChangeListener() {
				public void stateChanged(javax.swing.event.ChangeEvent e) {
					SliderSpinner.this.changeValue(sldValue.getValue(),
							e.getSource());
				}
			});
		}
		return sldValue;
	}

	private JSpinner getSpnValue() {
		if (spnValue == null) {
			spnValue = new JSpinner();
			spnValue.setModel(new SpinnerNumberModel(0, 0, 255, 1));
			spnValue.addChangeListener(new javax.swing.event.ChangeListener() {
				public void stateChanged(javax.swing.event.ChangeEvent e) {
					SliderSpinner.this.changeValue(
							(Integer) spnValue.getValue(), e.getSource());
				}
			});
			NumberEditor editor = new NumberEditor(spnValue, "000");
			spnValue.setEditor(editor);
			editor.getTextField().addKeyListener(new KeyAdapter() {
				@Override
				public void keyPressed(KeyEvent e) {
					switch (e.getKeyCode()) {
					case KeyEvent.VK_PAGE_DOWN:
						SliderSpinner.this.incrementValue(false,
								e.isControlDown());
						break;
					case KeyEvent.VK_PAGE_UP:
						SliderSpinner.this.incrementValue(true,
								e.isControlDown());
						break;
					case KeyEvent.VK_UP:
						if (e.isControlDown()) {
							SliderSpinner.this.incrementValue(true, true);
						}
						break;
					case KeyEvent.VK_DOWN:
						if (e.isControlDown()) {
							SliderSpinner.this.incrementValue(false, true);
						}
						break;
					case KeyEvent.VK_HOME:
						if (e.isControlDown()) {
							SliderSpinner.this.changeValue(MIN_VALUE, null);
						}
						break;
					case KeyEvent.VK_END:
						if (e.isControlDown()) {
							SliderSpinner.this.changeValue(MAX_VALUE, null);
						}
						break;
					}
				}
			});
		}

		return spnValue;
	}

	public int getValue() {
		return value;
	}

	public void setValue(int value) {
		if ((value < MIN_VALUE) || (value > MAX_VALUE)) {
			throw new IllegalArgumentException("Valor deve estar entre " + MIN_VALUE + " e " + MAX_VALUE);
		}
		
		this.changeValue(value, null);
	}

	public String getTitle() {
		return this.lblTitle.getText();
	}

	public void setTitle(String title) {
		this.lblTitle.setText(title);
	}

} // @jve:decl-index=0:visual-constraint="40,45"

package colorselector;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

public class TesteSliderSpinner extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel jContentPane = null;
	private SliderSpinner sliderSplinner = null;
	private JTextField txfValor = null;

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				TesteSliderSpinner thisClass = new TesteSliderSpinner();
				thisClass.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
				thisClass.setVisible(true);
			}
		});
	}

	/**
	 * This is the default constructor
	 */
	public TesteSliderSpinner() {
		super();
		initialize();
	}

	/**
	 * This method initializes this
	 * 
	 * @return void
	 */
	private void initialize() {
		this.setSize(300, 200);
		this.setContentPane(getJContentPane());
		this.setTitle("Teste de SliderSpinner");
	}

	/**
	 * This method initializes jContentPane
	 * 
	 * @return javax.swing.JPanel
	 */
	private JPanel getJContentPane() {
		if (jContentPane == null) {
			GridBagConstraints gridBagConstraints = new GridBagConstraints();
			gridBagConstraints.fill = GridBagConstraints.VERTICAL;
			gridBagConstraints.gridy = 1;
			gridBagConstraints.weightx = 1.0;
			gridBagConstraints.gridx = 0;
			jContentPane = new JPanel();
			jContentPane.setLayout(new GridBagLayout());
			jContentPane.add(getSliderSplinner(), new GridBagConstraints());
			jContentPane.add(getTxfValor(), gridBagConstraints);
		}
		return jContentPane;
	}

	private SliderSpinner getSliderSplinner() {
		if (sliderSplinner == null) {
			sliderSplinner = new SliderSpinner();
			sliderSplinner.setTitle("RGB");
			sliderSplinner.setValue(203);
			sliderSplinner
					.addPropertyChangeListener(new PropertyChangeListener() {
						@Override
						public void propertyChange(PropertyChangeEvent evt) {
							if (evt.getPropertyName().equals(
									SliderSpinner.PROP_VALUE)) {
								txfValor.setText(evt.getNewValue().toString());
							}
						}
					});
		}
	
		return sliderSplinner;
	}

	/**
	 * This method initializes txfValor
	 * 
	 * @return javax.swing.JTextField
	 */
	private JTextField getTxfValor() {
		if (txfValor == null) {
			txfValor = new JTextField();
			txfValor.setEditable(false);
			txfValor.setText("XXX");
			txfValor.setHorizontalAlignment(JTextField.RIGHT);
			txfValor.setEnabled(true);
			txfValor.addMouseListener(new java.awt.event.MouseAdapter() {
				public void mouseClicked(java.awt.event.MouseEvent e) {
					if(e.getClickCount() == 2) {
						sliderSplinner.setValue((int) (Math.random() * 290));
					}
				}
			});
		}
		return txfValor;
	}

}

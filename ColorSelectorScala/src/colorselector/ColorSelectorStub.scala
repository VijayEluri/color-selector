/**
 * 
 */
package colorselector

import scala.collection.mutable._
import scala.swing._
import scala.swing.GridBagPanel._
import scala.swing.GridBagPanel.Anchor._
import scala.swing.GridBagPanel.Fill._
import scala.swing.FlowPanel._
//import java.awt.Insets

/**
 * @author rafael
 *
 */
object ColorSelectorStub extends SimpleSwingApplication {
  import BorderPanel._

  val myMenuBar = new MenuBar {
    contents += new Menu("File")
    contents += new Menu("Options")
    contents += new Menu("Help")
  }

  val pnlSliderR = new BorderPanel {
    layout(new Button("pnlSliderR")) = Position.Center
  }

  val pnlSliderG = new BorderPanel {
    layout(new Button("pnlSliderG")) = Position.Center
  }

  val pnlSliderB = new BorderPanel {
    layout(new Button("pnlSliderB")) = Position.Center
  }

  val pnlSliderA = new BorderPanel {
    layout(new Button("pnlSliderA")) = Position.Center
  }

  val lblTitleWebColor = new Label("Web Colors")

  val lblTitleColorCode = new Label("Colors Code")

  val lblTitleColorFormat = new Label("Color Format")

  val chbEnableAlpha = new CheckBox("Enable Alpha")

  val cmbWebColor = new ComboBox(List("UNDEFINED"))

  val txfColorValue = new TextField() {
    preferredSize = new Dimension(100, 20)
    minimumSize = preferredSize
    editable = false
  }

  val cmbFormat = new ComboBox(List("RGB"))

  lazy val pnlControls = new GridBagPanel {
    maximumSize = new Dimension(800, 300)

    val insetsBase = new Insets(5, 5, 5, 5)

    //new Constraints (gridx: Int, gridy: Int, gridwidth: Int, gridheight: Int, weightx: Double, weighty: Double, anchor: Int, fill: Int, insets: Insets, ipadx: Int, ipady: Int) 
    layout(pnlSliderR) = new Constraints(0, 0, 1, 1, 4.0, 0, Anchor.Center.id, Fill.Horizontal.id, insetsBase, 0, 0)
    layout(pnlSliderG) = new Constraints(0, 1, 1, 1, 4.0, 0, Anchor.Center.id, Fill.Horizontal.id, insetsBase, 0, 0)
    layout(pnlSliderB) = new Constraints(0, 2, 1, 1, 4.0, 0, Anchor.Center.id, Fill.Horizontal.id, insetsBase, 0, 0)
    layout(pnlSliderA) = new Constraints(0, 3, 1, 1, 4.0, 0, Anchor.Center.id, Fill.Horizontal.id, insetsBase, 0, 0)

    layout(lblTitleWebColor) = new Constraints(1, 0, 1, 1, 0, 0, Anchor.East.id, Fill.None.id, new Insets(5, 10, 5, 5), 0, 0)
    layout(lblTitleColorCode) = new Constraints(1, 1, 1, 1, 0, 0, Anchor.East.id, Fill.None.id, new Insets(5, 10, 5, 5), 0, 0)
    layout(lblTitleColorFormat) = new Constraints(1, 2, 1, 1, 0, 0, Anchor.East.id, Fill.None.id, new Insets(5, 10, 5, 5), 0, 0)
    layout(chbEnableAlpha) = new Constraints(1, 3, 2, 1, 0, 0, Anchor.West.id, Fill.None.id, new Insets(5, 10, 5, 5), 0, 0)

    layout(cmbWebColor) = new Constraints(2, 0, 1, 1, 1.0, 0, Anchor.West.id, Fill.None.id, new Insets(5, 10, 5, 5), 0, 0)
    layout(txfColorValue) = new Constraints(2, 1, 1, 1, 1.0, 0, Anchor.West.id, Fill.Horizontal.id, new Insets(5, 10, 5, 5), 0, 0)
    layout(cmbFormat) = new Constraints(2, 2, 1, 1, 1.0, 0, Anchor.West.id, Fill.None.id, new Insets(5, 10, 5, 5), 0, 0)
  }

  lazy val pnlColor = new BorderPanel {
    layout(new Button("pnlColor")) = Position.Center
  }

  def top = new MainFrame {
    contents = new GridPanel(2, 1) {
      vGap = 5
      hGap = 5
      contents += pnlColor
      contents += pnlControls
    }
    menuBar = myMenuBar
    preferredSize = new java.awt.Dimension(800, 600)
    size = new java.awt.Dimension(800, 350)
    title = "Teste de Color Selector"
  }
}
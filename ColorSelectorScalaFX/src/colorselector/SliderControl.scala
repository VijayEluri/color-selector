/**
 *
 */
package colorselector

import colorselector.Max
import colorselector.Min
import colorselector.insets
import colorselector.doubleToInt
import javafx.beans.property.SimpleBooleanProperty
import javafx.beans.property.SimpleDoubleProperty
import javafx.event.EventHandler
import javafx.scene.input.ScrollEvent
import javafx.scene.layout.Priority
import scalafx.Includes.jfxBooleanProperty2sfx
import scalafx.Includes.jfxDoubleProperty2sfx
import scalafx.Includes.jfxStringProperty2sfx
import scalafx.beans.property.DoubleProperty.sfxDoubleProperty2jfx
import scalafx.beans.property.BooleanProperty
import scalafx.beans.property.DoubleProperty
import scalafx.scene.control.CheckBox
import scalafx.scene.control.Label
import scalafx.scene.control.Slider
import scalafx.scene.layout.HBox
import scalafx.beans.property.ObjectProperty
import javafx.beans.property.SimpleObjectProperty
import scalafx.beans.property.StringProperty
import javafx.beans.property.SimpleStringProperty
import scalafx.scene.paint.Color
import scalafx.scene.text.Font
import javafx.scene.text.FontWeight

/**
 * @author Rafael
 *
 */
class SliderControl(title: String) extends HBox {

  private val strBackground = "-fx-background-color: rgb(%d, %d, %d);"
  private val strForeground = "-fx-text-fill: rgb(%d, %d, %d);"

  private val cssBackground = new StringProperty(new SimpleStringProperty)
  private val cssForeground = new StringProperty(new SimpleStringProperty)

  val realValue = new DoubleProperty(new SimpleDoubleProperty)
  def value = this.realValue
  def value_=(d: Double) {
    if (d < Min) {
      value() = Min
    } else if (d > Max) {
      value() = Max
    } else {
      value() = d
    }
  }

  val selectedControl = new BooleanProperty(new SimpleBooleanProperty)

  val chbSelected = new CheckBox {
    id = "chbSelected"
    selected <==> selectedControl
  }

  val lblTitle = new Label {
    id = "lblTitle"
    text = title
    style <== cssForeground
  }
  lblTitle.font = Font.font(lblTitle.font.get().getFamily(), FontWeight.BOLD, lblTitle.font.get().getSize())

  val sldValue = new Slider {
    id = "sldValue"
    blockIncrement = 1.0
    majorTickUnit = 50.0
    max = Max
    min = Min
    minorTickCount = 4
    showTickLabels = true
    showTickMarks = true
//    style = ".slider .axis {-fx-tick-label-fill: green;}"
    hgrow = Priority.ALWAYS
    style <== cssForeground
    value <==> realValue
  }

  val lblValue = new Label {
    id = "lblValue"
    text <== realValue.asString("%03.0f")
    hgrow = Priority.NEVER
    style <== cssForeground
  }
  lblValue.font = Font.font(lblValue.font.get().getFamily(), FontWeight.BOLD, lblValue.font.get().getSize())

  content = List(chbSelected, lblTitle, sldValue, lblValue)

  padding = insets

  style <== cssBackground

  onScroll = new EventHandler[ScrollEvent] {
    def handle(event: ScrollEvent) {

      if (event.getEventType == ScrollEvent.SCROLL) {
        val multiplier = if (event.isControlDown()) 10 else 1
        val delta = -(event.getDeltaY.toInt / 10)

        value = (value.get + multiplier * delta)
      }
    }

  }

  def changeColor(backgroundColor: Color, foregroundColor: Color) {
    this.cssBackground() = strBackground.format(doubleToInt(backgroundColor.red),
      doubleToInt(backgroundColor.green), doubleToInt(backgroundColor.blue))
    this.cssForeground() = strForeground.format(doubleToInt(foregroundColor.red),
      doubleToInt(foregroundColor.green), doubleToInt(foregroundColor.blue))
  }

  override def toString = "%s[%s, %b]".format(title, lblValue.text.get, selectedControl.value)
}
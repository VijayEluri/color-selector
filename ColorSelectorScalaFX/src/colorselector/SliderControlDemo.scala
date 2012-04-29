package colorselector

import scalafx.application.JFXApp
import scalafx.scene.control._
import javafx.geometry.Pos
import javafx.scene.layout.Priority
import scalafx.stage.Stage
import scalafx.scene.Scene
import scalafx.scene.paint.Color
import scalafx.scene.layout._
import scalafx.Includes._

object SliderControlDemo extends JFXApp {

  val sliderControl = new SliderControl("X")

  val txfInputValue = new TextField {
    alignment = Pos.BASELINE_LEFT
    promptText = "Enter the value"
    hgrow = Priority.NEVER
    onAction = {
      try {
        sliderControl.value = text.get.toDouble
      } finally {
        text = ""
      }
    }
    //GridPane.columnIndex="1" GridPane.halignment="LEFT" GridPane.hgrow="NEVER" 
    //GridPane.rowIndex="0" GridPane.valignment="BASELINE" GridPane.vgrow="NEVER"
  }

  val lblOutputValue = new Label {
    alignment = Pos.BASELINE_LEFT
    text <== sliderControl.realValue.asString("%03.0f")
  }

  stage = new Stage {
    title = "SliderControl Demo"
    width = 600
    height = 300
    scene = new Scene {
      fill = Color.LIGHTGRAY
      content = new VBox(5.0) {
        content = List(sliderControl,
          new GridPane {
            add(new Label {
              text = "Input Value"
            }, 0, 0)
            add(txfInputValue, 1, 0)
            add(new Label {
              text = "Output Value"
            }, 2, 0)
            add(lblOutputValue, 3, 0)
          })
      }
    }
  }

}
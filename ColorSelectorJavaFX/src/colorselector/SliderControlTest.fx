/*
 * SliderControlTest.fx
 *
 * Created on 11/12/2010, 21:52:52
 */
package colorselector;

import javafx.scene.layout.LayoutInfo;
import java.lang.NumberFormatException;

/**
 * @author rafael
 */
public class SliderControlTest {

    def sliderControl = SliderControl {
                backgroundColor: bind (chbInputBackground.selectedItem as WebColor).getColor()
                foregroundColor: bind (chbInputForeground.selectedItem as WebColor).getColor()
            }

    init {
    // see: http://netbeans.org/kb/docs/javafx/fragments.html
        insert sliderControl.node after verticalBox.content[1];
    }

    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:main
    public-read def separator: javafx.scene.control.Separator = javafx.scene.control.Separator {
    }
    
    public-read def exitMenuItem: com.javafx.preview.control.MenuItem = com.javafx.preview.control.MenuItem {
        text: "Exit"
        action: FX.exit
    }
    
    public-read def fileMenu: com.javafx.preview.control.Menu = com.javafx.preview.control.Menu {
        text: "File"
        items: [ separator, exitMenuItem, ]
    }
    
    public-read def editMenu: com.javafx.preview.control.Menu = com.javafx.preview.control.Menu {
        text: "Edit"
    }
    
    public-read def aboutMenuItem: com.javafx.preview.control.MenuItem = com.javafx.preview.control.MenuItem {
        text: "About"
    }
    
    public-read def helpMenu: com.javafx.preview.control.Menu = com.javafx.preview.control.Menu {
        text: "Help"
        items: [ aboutMenuItem, ]
    }
    
    def __layoutInfo_menuBar: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
    }
    public-read def menuBar: com.javafx.preview.control.MenuBar = com.javafx.preview.control.MenuBar {
        layoutX: 0.0
        layoutY: 0.0
        layoutInfo: __layoutInfo_menuBar
        menus: [ fileMenu, editMenu, helpMenu, ]
    }
    
    def __layoutInfo_lblInput: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 4
    }
    public-read def lblInput: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblInput
        text: "Input Data"
        font: null
        hpos: javafx.geometry.HPos.RIGHT
        graphicHPos: javafx.geometry.HPos.RIGHT
    }
    
    def __layoutInfo_slider: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        hfill: true
    }
    public-read def slider: javafx.scene.control.Slider = javafx.scene.control.Slider {
        layoutInfo: __layoutInfo_slider
        min: -50.0
        max: 300.0
        value: bind sliderControl.value with inverse
        clickToPosition: true
        majorTickUnit: 50.0
        minorTickCount: 2
        showTickLabels: true
        showTickMarks: true
        labelFormatter: sliderLabelFormatter
    }
    
    public-read def lblInputTitle: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Title"
        font: null
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
        graphicHPos: javafx.geometry.HPos.RIGHT
    }
    
    public-read def lblInputBackground: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Background"
    }
    
    def __layoutInfo_chbInputForeground: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 1
    }
    public-read def chbInputForeground: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
        layoutInfo: __layoutInfo_chbInputForeground
        items: chbInputColorItems ()
    }
    
    public-read def lblInputForeground: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Foreground"
    }
    
    public-read def lblInputValue: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Value"
        font: null
    }
    
    public-read def txbInputTitle: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        text: bind sliderControl.title with inverse
    }
    
    public-read def lblInputSelected: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Selected"
        font: null
    }
    
    public-read def chbSelected: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
        disable: false
        text: ""
        hpos: null
        graphicHPos: null
        selected: bind sliderControl.selected with inverse
    }
    
    public-read def lblInputEnabled: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Disabled"
        font: null
    }
    
    public-read def chbEnabled: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
        selected: bind sliderControl.disable with inverse
    }
    
    def __layoutInfo_label: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        height: 15.0
    }
    public-read def label: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_label
        text: "R\u00F3tulo"
    }
    
    def __layoutInfo_chbInputBackground: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 1
    }
    public-read def chbInputBackground: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
        layoutInfo: __layoutInfo_chbInputBackground
        items: chbInputColorItems ()
    }
    
    public-read def txbInputValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        action: txbInputValueAction
    }
    
    def __layoutInfo_gridInput: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
    }
    public-read def gridInput: com.javafx.preview.layout.Grid = com.javafx.preview.layout.Grid {
        layoutInfo: __layoutInfo_gridInput
        hgap: 6.0
        vgap: 6.0
        rows: [
            com.javafx.preview.layout.GridRow {
                cells: [ lblInput, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblInputTitle, txbInputTitle, lblInputSelected, chbSelected, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblInputValue, slider, lblInputEnabled, chbEnabled, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblInputBackground, chbInputBackground, label, txbInputValue, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblInputForeground, chbInputForeground, ]
            }
        ]
    }
    
    def __layoutInfo_lblOutput: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 4
    }
    public-read def lblOutput: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutX: 0.0
        layoutY: 0.0
        layoutInfo: __layoutInfo_lblOutput
        text: "Output Values"
        font: null
    }
    
    public-read def lblOuputTitle: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Title"
    }
    
    public-read def txbOutputTitle: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        text: bind sliderControl.title
        editable: false
    }
    
    def __layoutInfo_txbOutputBackground: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 3
    }
    public-read def txbOutputBackground: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        layoutInfo: __layoutInfo_txbOutputBackground
        text: bind {sliderControl.backgroundColor.toString()}
        editable: false
    }
    
    def __layoutInfo_txtOutputForeground: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 3
    }
    public-read def txtOutputForeground: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        layoutInfo: __layoutInfo_txtOutputForeground
        text: bind {sliderControl.foregroundColor.toString()}
        editable: false
    }
    
    public-read def lblOutputForeground: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Foreground"
    }
    
    public-read def lblOutputBackground: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Background"
    }
    
    public-read def lblOutputValue: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Value"
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
        graphicHPos: javafx.geometry.HPos.RIGHT
    }
    
    public-read def txbOutputValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        text: bind "{sliderControl.value}"
        editable: false
    }
    
    public-read def lblOutputSelected: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Selected"
    }
    
    public-read def txtOutputSelected: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        text: bind "{sliderControl.selected}"
        editable: false
    }
    
    public-read def lblOutputEnabled: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Disabled"
    }
    
    public-read def txbOutputEnabled: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        layoutX: 97.0
        layoutY: 222.0
        text: bind "{sliderControl.disable}"
        editable: false
    }
    
    def __layoutInfo_gridOutput: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
    }
    public-read def gridOutput: com.javafx.preview.layout.Grid = com.javafx.preview.layout.Grid {
        layoutInfo: __layoutInfo_gridOutput
        hgap: 6.0
        vgap: 6.0
        rows: [
            com.javafx.preview.layout.GridRow {
                cells: [ lblOutput, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblOuputTitle, txbOutputTitle, lblOutputSelected, txtOutputSelected, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblOutputValue, txbOutputValue, lblOutputEnabled, txbOutputEnabled, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblOutputBackground, txbOutputBackground, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblOutputForeground, txtOutputForeground, ]
            }
        ]
    }
    
    def __layoutInfo_verticalBox: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
        height: bind scene.height
    }
    public-read def verticalBox: javafx.scene.layout.VBox = javafx.scene.layout.VBox {
        layoutX: 0.0
        layoutY: 0.0
        layoutInfo: __layoutInfo_verticalBox
        content: [ menuBar, gridInput, gridOutput, ]
        spacing: 6.0
    }
    
    public-read def scene: javafx.scene.Scene = javafx.scene.Scene {
        width: 476.0
        height: 318.0
        content: getDesignRootNodes ()
    }
    
    public-read def currentState: org.netbeans.javafx.design.DesignState = org.netbeans.javafx.design.DesignState {
    }
    
    public function getDesignRootNodes (): javafx.scene.Node[] {
        [ verticalBox, ]
    }
    
    public function getDesignScene (): javafx.scene.Scene {
        scene
    }
    // </editor-fold>//GEN-END:main

    function txbInputValueAction(): Void {
        try {
            this.sliderControl.value = Float.valueOf(txbInputValue.text);
            println("**{this.sliderControl.value}**")
        } catch (e: NumberFormatException) {
            e.printStackTrace();
        }
        txbInputValue.text = "";
    }

    function sliderLabelFormatter(value: Number): String {
        "{



%.0f value}"
    }

    function chbInputColorItems(): Object[] {
        WebColor.values
         }

}

function run (): Void {
    var design = SliderControlTest {};

    javafx.stage.Stage {
        title: "SliderControlTest"
        scene: design.getDesignScene ()
    }
}

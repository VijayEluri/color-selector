/*
 * SliderControlTest.fx
 *
 * Created on 11/12/2010, 21:52:52
 */
package colorselector;

import javafx.scene.layout.LayoutInfo;

/**
 * @author rafael
 */
public class SliderControlTest {

    init {
        insert sliderControl.hrbSliderControl after verticalBox.content[0];
    }

    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:main
    public-read def chbSelected: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
        text: ""
    }
    
    public-read def txbInputTitle: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
    }
    
    public-read def txbInputValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
    }
    
    def __layoutInfo_pnlSlider: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
        hfill: true
        hgrow: javafx.scene.layout.Priority.ALWAYS
        hshrink: javafx.scene.layout.Priority.ALWAYS
    }
    public-read def pnlSlider: javafx.scene.layout.Panel = javafx.scene.layout.Panel {
        layoutInfo: __layoutInfo_pnlSlider
    }
    
    public-read def lblOuputTitle: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Title"
    }
    
    public-read def txbOutputTitle: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        editable: false
    }
    
    public-read def lblOutputValue: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Value"
    }
    
    public-read def txbOutputValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        editable: false
    }
    
    public-read def lblOutputSelected: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Selected"
    }
    
    public-read def txtOutputSelected: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        editable: false
    }
    
    public-read def fontPrimaryTitles: javafx.scene.text.Font = javafx.scene.text.Font {
        oblique: false
        embolden: false
        autoKern: false
        ligatures: false
    }
    
    def __layoutInfo_lblOutput: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 2
    }
    public-read def lblOutput: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutX: 0.0
        layoutY: 0.0
        layoutInfo: __layoutInfo_lblOutput
        text: "Output Values"
        font: fontPrimaryTitles
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
                cells: [ lblOuputTitle, txbOutputTitle, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblOutputValue, txbOutputValue, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblOutputSelected, txtOutputSelected, ]
            }
        ]
    }
    
    def __layoutInfo_lblInput: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 2
    }
    public-read def lblInput: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblInput
        text: "Input Data"
        font: fontPrimaryTitles
        hpos: javafx.geometry.HPos.RIGHT
        graphicHPos: javafx.geometry.HPos.RIGHT
    }
    
    public-read def fontSecondTitles: javafx.scene.text.Font = javafx.scene.text.Font {
        oblique: false
        ligatures: false
    }
    
    public-read def lblInputValue: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Value"
        font: fontSecondTitles
    }
    
    public-read def lblInputTitle: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Title"
        font: fontSecondTitles
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
        graphicHPos: javafx.geometry.HPos.RIGHT
    }
    
    public-read def lblInputSelected: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Selected"
        font: fontSecondTitles
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
                cells: [ lblInputTitle, txbInputTitle, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblInputValue, txbInputValue, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ lblInputSelected, chbSelected, ]
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
        content: [ gridInput, pnlSlider, gridOutput, ]
        spacing: 6.0
    }
    
    public-read def scene: javafx.scene.Scene = javafx.scene.Scene {
        width: 240.0
        height: 320.0
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

    def sliderControl = SliderControl {
            }
}

function run (): Void {
    var design = SliderControlTest {};

    javafx.stage.Stage {
        title: "SliderControlTest"
        scene: design.getDesignScene ()
    }
}

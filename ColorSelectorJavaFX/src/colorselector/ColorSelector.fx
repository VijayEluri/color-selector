/*
 * ColorSelector.fx
 *
 * Created on 10/12/2010, 21:40:11
 */
package colorselector;

/**
 * @author rafael
 */
public class ColorSelector {

//    var lineControlHeight = bind scene.height / 8;
    var pos0 = 0;
    var width0 = bind scene.width / 2;
    var pos1 = bind (pos0 + width0);
    var width1 = bind (2 * scene.width / 10);
    var pos2 = bind (pos1 + width1);
    var width2 = bind 3 * scene.width / 10;

    bound function sliderWidth(): Number {
        scene.width / 2
    }



    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:main
    def __layoutInfo_rectangle: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        hgrow: javafx.scene.layout.Priority.ALWAYS
        vgrow: javafx.scene.layout.Priority.ALWAYS
    }
    public-read def rectangle: javafx.scene.shape.Rectangle = javafx.scene.shape.Rectangle {
        layoutInfo: __layoutInfo_rectangle
        width: bind scene.width
        height: bind scene.height / 2
    }
    
    def __layoutInfo_btnRed: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width0
    }
    public-read def btnRed: javafx.scene.control.Button = javafx.scene.control.Button {
        layoutInfo: __layoutInfo_btnRed
        text: "RED"
        textAlignment: javafx.scene.text.TextAlignment.CENTER
    }
    
    def __layoutInfo_lblTitleWebColor: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width1
    }
    public-read def lblTitleWebColor: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblTitleWebColor
        text: "Web Color:"
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
    }
    
    public-read def chbWebColors: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
        items: [ "Item 1", "Item 2", "Item 3", ]
    }
    
    def __layoutInfo_hrbControl0: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
    }
    public-read def hrbControl0: javafx.scene.layout.HBox = javafx.scene.layout.HBox {
        layoutInfo: __layoutInfo_hrbControl0
        content: [ btnRed, lblTitleWebColor, chbWebColors, ]
        spacing: 6.0
        vpos: javafx.geometry.VPos.BASELINE
        nodeVPos: javafx.geometry.VPos.BASELINE
    }
    
    def __layoutInfo_btnGreen: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width0
    }
    public-read def btnGreen: javafx.scene.control.Button = javafx.scene.control.Button {
        layoutInfo: __layoutInfo_btnGreen
        text: "GREEN"
    }
    
    public-read def lblTitleColor: javafx.scene.control.Label = javafx.scene.control.Label {
        text: "Color Code:"
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
    }
    
    def __layoutInfo_btnBlue: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width0
    }
    public-read def btnBlue: javafx.scene.control.Button = javafx.scene.control.Button {
        layoutInfo: __layoutInfo_btnBlue
        text: "BLUE"
    }
    
    def __layoutInfo_lblTitleColorFormat: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width1
    }
    public-read def lblTitleColorFormat: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblTitleColorFormat
        text: "Color Format"
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
    }
    
    public-read def cmbColorFormat: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
        items: [ "Item 1", "Item 2", "Item 3", ]
    }
    
    def __layoutInfo_hrbControl2: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
    }
    public-read def hrbControl2: javafx.scene.layout.HBox = javafx.scene.layout.HBox {
        layoutInfo: __layoutInfo_hrbControl2
        content: [ btnBlue, lblTitleColorFormat, cmbColorFormat, ]
        spacing: 6.0
        nodeVPos: javafx.geometry.VPos.BASELINE
    }
    
    def __layoutInfo_btnAlpha: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width0
    }
    public-read def btnAlpha: javafx.scene.control.Button = javafx.scene.control.Button {
        layoutInfo: __layoutInfo_btnAlpha
        text: "ALPHA"
    }
    
    def __layoutInfo_chbEnableAlpha: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width0
    }
    public-read def chbEnableAlpha: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
        layoutInfo: __layoutInfo_chbEnableAlpha
        text: "Enable Alpha"
    }
    
    def __layoutInfo_hrbControl3: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
    }
    public-read def hrbControl3: javafx.scene.layout.HBox = javafx.scene.layout.HBox {
        layoutInfo: __layoutInfo_hrbControl3
        content: [ btnAlpha, chbEnableAlpha, ]
        spacing: 6.0
        nodeVPos: javafx.geometry.VPos.BASELINE
    }
    
    public-read def radialGradient: javafx.scene.paint.RadialGradient = javafx.scene.paint.RadialGradient {
        stops: [ javafx.scene.paint.Stop { offset: 0.0, color: javafx.scene.paint.Color.web ("#FF0000") }, javafx.scene.paint.Stop { offset: 1.0, color: javafx.scene.paint.Color.web ("#0000FF") }, ]
    }
    
    public-read def color: javafx.scene.paint.Color = javafx.scene.paint.Color {
        red: 0.6
    }
    
    public-read def color2: javafx.scene.paint.Color = javafx.scene.paint.Color {
        red: 0.4
        green: 1.0
        blue: 0.2
    }
    
    public-read def fontColorValue: javafx.scene.text.Font = javafx.scene.text.Font {
        name: "monospaced"
    }
    
    public-read def txbColorValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        text: "rgb(255, 255, 255)"
        editable: false
        font: fontColorValue
    }
    
    def __layoutInfo_hrbControl1: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
    }
    public-read def hrbControl1: javafx.scene.layout.HBox = javafx.scene.layout.HBox {
        layoutInfo: __layoutInfo_hrbControl1
        content: [ btnGreen, lblTitleColor, txbColorValue, ]
        spacing: 6.0
        nodeVPos: javafx.geometry.VPos.BASELINE
    }
    
    def __layoutInfo_vtbControls: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        hfill: true
        hgrow: javafx.scene.layout.Priority.ALWAYS
        vgrow: javafx.scene.layout.Priority.ALWAYS
        hshrink: javafx.scene.layout.Priority.ALWAYS
        vshrink: javafx.scene.layout.Priority.ALWAYS
    }
    public-read def vtbControls: javafx.scene.layout.VBox = javafx.scene.layout.VBox {
        layoutInfo: __layoutInfo_vtbControls
        content: [ hrbControl0, hrbControl1, hrbControl2, hrbControl3, ]
        spacing: 6.0
    }
    
    def __layoutInfo_verticalBox: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind scene.width
        height: bind scene.height
    }
    public-read def verticalBox: javafx.scene.layout.VBox = javafx.scene.layout.VBox {
        layoutX: 0.0
        layoutY: 0.0
        layoutInfo: __layoutInfo_verticalBox
        content: [ rectangle, vtbControls, ]
        spacing: 6.0
    }
    
    public-read def scene: javafx.scene.Scene = javafx.scene.Scene {
        width: 600.0
        height: 400.0
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


}

function run (): Void {
    var design = ColorSelector {};

    javafx.stage.Stage {
        title: "Color Selector"
        scene: design.getDesignScene ()
    }
}

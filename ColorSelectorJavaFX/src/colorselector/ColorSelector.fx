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
    //var width0 = bind scene.width / 2;
  //  var pos1 = bind (pos0 + width0);
    var width1 = 150;  // bind (2 * scene.width / 10);
//    var pos2 = bind (pos1 + width1);
//    var width2 = bind 3 * scene.width / 10;


    init {
//        this.grid.rows[0].cells[0] = this.sliderControlRed.node;
/*
        var cells0 = grid.rows[0].cells;
        insert sliderControlRed.node before cells0[0] ;
        println(this.grid.rows[0].cells[0]);
*/
    }

    public-read def sliderControlRed = SliderControl {
        title: 'R'
    }

    public-read def sliderControlGreen = SliderControl {
        title: 'G'
    }

    public-read def sliderControlBlue = SliderControl {
        title: 'B'
    }

    public-read def sliderControlAlpha = SliderControl {
        title: 'A'
        disable: true
    }





    def __layoutInfo_rectangle: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        hgrow: javafx.scene.layout.Priority.ALWAYS
        vgrow: javafx.scene.layout.Priority.ALWAYS
    }
    public-read def rectangle: javafx.scene.shape.Rectangle = javafx.scene.shape.Rectangle {
        layoutInfo: __layoutInfo_rectangle
        width: bind scene.width
        height: bind scene.height / 2
    }
    
    def __layoutInfo_lblTitleWebColor: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width1
        vpos: javafx.geometry.VPos.TOP
    }

    public-read def lblTitleWebColor: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblTitleWebColor
        text: "Web Color:"
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
    }

    def __layoutInfo_chbWebColors: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        vpos: javafx.geometry.VPos.TOP
    }
    public-read def chbWebColors: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
        layoutInfo: __layoutInfo_chbWebColors
        items: [ "Item 1", "Item 2", "Item 3", ]
    }
   
    def __layoutInfo_lblTitleColor: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width1
        vpos: javafx.geometry.VPos.TOP
    }
    public-read def lblTitleColor: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblTitleColor
        text: "Color Code:"
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
    }
    
    def __layoutInfo_lblTitleColorFormat: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width1
        vpos: javafx.geometry.VPos.TOP
    }
    public-read def lblTitleColorFormat: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblTitleColorFormat
        text: "Color Format"
        textAlignment: javafx.scene.text.TextAlignment.RIGHT
        hpos: javafx.geometry.HPos.RIGHT
    }
    
    def __layoutInfo_cmbColorFormat: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        vpos: javafx.geometry.VPos.TOP
    }
    public-read def cmbColorFormat: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
        layoutInfo: __layoutInfo_cmbColorFormat
        items: [ "Item 1", "Item 2", "Item 3", ]
    }
    
    def __layoutInfo_chbEnableAlpha: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        hspan: 2
        vpos: javafx.geometry.VPos.TOP
    }
    public-read def chbEnableAlpha: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
        layoutInfo: __layoutInfo_chbEnableAlpha
        text: "Enable Alpha"
    }
    
    public-read def fontColorValue: javafx.scene.text.Font = javafx.scene.text.Font {
        name: "monospaced"
    }
    
    def __layoutInfo_txbColorValue: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
        vpos: javafx.geometry.VPos.TOP
    }
    public-read def txbColorValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
        layoutInfo: __layoutInfo_txbColorValue
        text: "rgb(255, 255, 255)"
        editable: false
        font: fontColorValue
    }
    
    public-read def grid: com.javafx.preview.layout.Grid = com.javafx.preview.layout.Grid {
        hgap: 6.0
        vgap: 6.0
        rows: [
            com.javafx.preview.layout.GridRow {
                cells: [ this.sliderControlRed.node, lblTitleWebColor, chbWebColors, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ this.sliderControlGreen.node, lblTitleColor, txbColorValue, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ this.sliderControlBlue.node, lblTitleColorFormat, cmbColorFormat, ]
            }
            com.javafx.preview.layout.GridRow {
                cells: [ this.sliderControlAlpha.node, chbEnableAlpha, ]
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
        content: [ rectangle, grid, ]
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

}

function run (): Void {
    var design = ColorSelector {};

    javafx.stage.Stage {
        title: "Color Selector"
        scene: design.getDesignScene ()
    }
}

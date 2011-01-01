/*
 * ColorSelector.fx
 *
 * Created on 10/12/2010, 21:40:11
 */
package colorselector;

import javafx.scene.paint.Color;
import javafx.util.Math;
import javafx.scene.input.MouseEvent;
import colorselector.ColorFormatter;
import colorselector.WebColor;
import javafx.scene.paint.Paint;

/**
 * @author rafael
 */
public class ColorSelector {

    var width1 = 100;

    var controlsWidht = bind 0.6 * scene.width;

    var syncronizedControls: SliderControl[] = [];

    var currentFormatter: ColorFormatter = bind (cmbColorFormat.selectedItem) as ColorFormatter on replace {
                formatColor();
            }

    var currentWebColor: WebColor = bind (chbWebColors.selectedItem) as WebColor on replace {
                if (currentWebColor.defined) {
                    sliderControlRed.value = currentWebColor.red;
                    sliderControlGreen.value = currentWebColor.green;
                    sliderControlBlue.value = currentWebColor.blue;
                }
            }

    var currentColor: Paint = Color.WHITE on replace {
                this.formatColor();
                this.handleChbWebColors();
            }

    init {
        changeColors(null);
    }

    public-read def sliderControlRed: SliderControl = SliderControl {
                title: 'R'
                onChange: function() {
                    changeColors(sliderControlRed);
                }
                onSelect: function() {
                    syncronizeControl(sliderControlRed);
                }
                width: bind controlsWidht
                backgroundColor: bind Color.rgb(sliderControlRed.value, 0, 0)
                foregroundColor: bind getForegroundColor(sliderControlRed.value)
            }

    public-read def sliderControlGreen: SliderControl = SliderControl {
                title: 'G'
                onChange: function() {
                    changeColors(sliderControlGreen);
                }
                onSelect: function() {
                    syncronizeControl(sliderControlGreen);
                }
                width: bind controlsWidht
                backgroundColor: bind Color.rgb(0, sliderControlGreen.value, 0)
                foregroundColor: bind getForegroundColor(sliderControlGreen.value)
            }

    public-read def sliderControlBlue: SliderControl = SliderControl {
                title: 'B'
                onChange: function() {
                    changeColors(sliderControlBlue);
                }
                onSelect: function() {
                    syncronizeControl(sliderControlBlue);
                }
                width: bind controlsWidht
                backgroundColor: bind Color.rgb(0, 0, sliderControlBlue.value)
                foregroundColor: Color.WHITE
            }

    public-read def sliderControlAlpha: SliderControl = SliderControl {
                title: 'A'
                value: Utils.MAX
                disable: bind (not this.chbEnableAlpha.selected)
                onChange: function() {
                    changeColors(sliderControlAlpha);
                }
                onDisable: function() {
                    changeColors(sliderControlAlpha);
                    if (sliderControlAlpha.disable) {
                        sliderControlAlpha.selected = false;
                    }
                }
                onSelect: function() {
                    syncronizeControl(sliderControlAlpha);
                }
                width: bind controlsWidht
            }

    def __layoutInfo_rectangle: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
                hgrow: javafx.scene.layout.Priority.ALWAYS
                vgrow: javafx.scene.layout.Priority.ALWAYS
            }

    public-read def rectangle: javafx.scene.shape.Rectangle = javafx.scene.shape.Rectangle {
                layoutInfo: __layoutInfo_rectangle
                width: bind scene.width
                height: bind scene.height / 2
                fill: bind this.currentColor
                onMouseClicked: function(event: MouseEvent): Void {
                    if (event.clickCount == 2) {
                        shuffleColors()
                    }
                }
            }

    def __layoutInfo_lblTitleWebColor: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
                width: bind width1
                vpos: javafx.geometry.VPos.TOP
                hpos: javafx.geometry.HPos.RIGHT
            }

    public-read def lblTitleWebColor: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: __layoutInfo_lblTitleWebColor
                text: "Web Color:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    def __layoutInfo_chbWebColors: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
                vpos: javafx.geometry.VPos.TOP
            }

    public-read def chbWebColors: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
                layoutInfo: __layoutInfo_chbWebColors
                items: WebColor.values
            }

    def __layoutInfo_lblTitleColor: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
                width: bind width1
                vpos: javafx.geometry.VPos.TOP
                hpos: javafx.geometry.HPos.RIGHT
            }

    public-read def lblTitleColor: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: __layoutInfo_lblTitleColor
                text: "Color Code:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    def __layoutInfo_lblTitleColorFormat: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
                width: bind width1
                vpos: javafx.geometry.VPos.TOP
                hpos: javafx.geometry.HPos.RIGHT
            }

    public-read def lblTitleColorFormat: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: __layoutInfo_lblTitleColorFormat
                text: "Color Format:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    def __layoutInfo_cmbColorFormat: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
                vpos: javafx.geometry.VPos.TOP
            }

    public-read def cmbColorFormat: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
                layoutInfo: __layoutInfo_cmbColorFormat
                items: ColorFormatter.formatters
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
                size: 10
            }

    def __layoutInfo_txbColorValue: com.javafx.preview.layout.GridLayoutInfo = com.javafx.preview.layout.GridLayoutInfo {
                vpos: javafx.geometry.VPos.TOP
                minWidth: bind 0.3 * scene.width
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
                        cells: [this.sliderControlRed.node, lblTitleWebColor, chbWebColors,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlGreen.node, lblTitleColor, txbColorValue,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlBlue.node, lblTitleColorFormat, cmbColorFormat,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlAlpha.node, chbEnableAlpha,]
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
                content: [rectangle, grid,]
                spacing: 6.0
            }

    public-read def scene: javafx.scene.Scene = javafx.scene.Scene {
                width: 600.0
                height: 400.0
                content: getDesignRootNodes()
            }

    public function getDesignRootNodes(): javafx.scene.Node[] {
        [verticalBox,]
    }

    public function getDesignScene(): javafx.scene.Scene {
        scene
    }

    function formatColor(): Void {
        this.txbColorValue.text = currentFormatter.format(this.currentColor as Color, not sliderControlAlpha.disable);
    }

    function syncronizeControl(source: SliderControl): Void {
        if (source.selected) {
            insert source into this.syncronizedControls;

            var size = sizeof this.syncronizedControls;
            if (size > 1) {
                var sum = 0.0;
                for (control in this.syncronizedControls) {
                    sum += control.value;
                }
                def newValue = sum / size;
                for (control in this.syncronizedControls) {
                    control.value = newValue;
                }
            }
        } else {
            delete source from this.syncronizedControls;
        }
    }

    function getRandom(): Number {
        Math.random() * Utils.MAX;
    }

    function shuffleColors(): Void {
        def hasSync = (sizeof this.syncronizedControls > 1);
        def syncValue = if (hasSync) this.getRandom() else 0.0;

        this.sliderControlRed.value = if (hasSync and this.sliderControlRed.selected) syncValue else this.getRandom();
        this.sliderControlGreen.value = if (hasSync and this.sliderControlGreen.selected) syncValue else this.getRandom();
        this.sliderControlBlue.value = if (hasSync and this.sliderControlBlue.selected) syncValue else this.getRandom();
        if (not this.sliderControlAlpha.disable) {
            this.sliderControlAlpha.value = if (hasSync and this.sliderControlAlpha.selected) syncValue else this.getRandom();
        }
    }

    function changeColors(source: SliderControl): Void {
        if ((source != null) and source.selected and (sizeof this.syncronizedControls > 1)) {
            for (control in this.syncronizedControls) {
                if ((control != source) and (control.value != source.value)) {
                    control.value = source.value;
                }
            }
        }

        var alpha = if (this.sliderControlAlpha.disable) 1.0 else (this.sliderControlAlpha.value / Utils.MAX);
        this.currentColor = Color.rgb(this.sliderControlRed.value,
                this.sliderControlGreen.value,
                this.sliderControlBlue.value, alpha);
    }

    function getForegroundColor(value: Number): Color {
        if (value > (Utils.MAX) / 2) then Color.BLACK else Color.WHITE
    }

    function handleChbWebColors(): Void {
        var index = 0;
        var found = false;
        for (item in this.chbWebColors.items) {
            var webColor: WebColor = item as WebColor;
            if (webColor.defined
                    and (webColor.red == Utils.colorValueToInt((currentColor as Color).red))
                    and (webColor.green == Utils.colorValueToInt((currentColor as Color).green))
                    and (webColor.blue == Utils.colorValueToInt((currentColor as Color).blue))) {
                this.chbWebColors.select(index);
                found = true;
                break;
            }
            index++;
        }

        if (not found) {
            this.chbWebColors.select(0);
        }

    }

}

function run(): Void {
    var design = ColorSelector {};

    javafx.stage.Stage {
        title: "Color Selector"
        scene: design.getDesignScene()
    }
}

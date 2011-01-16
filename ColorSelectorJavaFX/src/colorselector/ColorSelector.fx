/*
 * ColorSelector.fx
 *
 * Created on 10/12/2010, 21:40:11
 */
package colorselector;

import colorselector.ColorFormatter;
import colorselector.WebColor;
import com.javafx.preview.control.Menu;
import com.javafx.preview.control.MenuBar;
import com.javafx.preview.control.MenuItem;
import com.javafx.preview.control.CheckMenuItem;
import com.javafx.preview.control.RadioMenuItem;
import com.javafx.preview.layout.GridLayoutInfo;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;
import javafx.scene.control.Separator;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.Tooltip;
import javafx.scene.effect.Reflection;
import javafx.scene.text.Font;
import javafx.scene.paint.Paint;
import javafx.scene.layout.LayoutInfo;
import javafx.stage.Alert;
import javafx.util.Math;
import javafx.scene.control.TextBox;
import javafx.scene.input.KeyEvent;
import javafx.scene.control.Control;
import javafx.scene.Parent;
import javafx.scene.layout.Priority;

/**
 * @author rafael
 */
public class ColorSelector {

    var width1 = 100;

    var controlsWidht = bind 0.5 * scene.width;

    var syncronizedControls: SliderControl[] = [];

    def titlesLayout = LayoutInfo {
                hpos: javafx.geometry.HPos.RIGHT
                hfill: true
                minWidth: width1
                vpos: javafx.geometry.VPos.TOP
                width: width1
            }

    var gridWebColor: com.javafx.preview.layout.GridRow;

    var visibleControlWebColor: Control;

    var selectedWebColors: Object[] = [];

    var containerWebColors: Parent = javafx.scene.layout.Flow {
                content: bind visibleControlWebColor
                nodeVPos: javafx.geometry.VPos.TOP
                nodeHPos: javafx.geometry.HPos.RIGHT
                layoutInfo: LayoutInfo {
                    hgrow: Priority.ALWAYS
                }
            };

    var formatGroup = ToggleGroup {}

    var panelsHeight: Number = bind (scene.height - menuBar.height) / 2;

    var currentFormatter: ColorFormatter = bind (cmbColorFormat.selectedItem) as ColorFormatter on replace {
                formatColor();
                formatGroup.toggles[cmbColorFormat.selectedIndex].selected = true;
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
        this.visibleControlWebColor = this.chbWebColors;
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

    public-read def menuBar: MenuBar = MenuBar {
                layoutInfo: LayoutInfo {
                    width: bind scene.width
                }
                layoutX: 0.0
                layoutY: 0.0
                menus: [
                    Menu {
                        text: ##[menu.file]"File"
                        items: [
                            MenuItem {
                                text: ##[random_color]"Random Color"
                                action: shuffleColors
                            }
                            MenuItem {
                                text: "Trocar componente"
                                action: swapWebColorComponent
                            }
                            Separator {}
                            MenuItem {
                                text: ##[menu.file.exit]"Exit"
                                action: FX.exit
                            }
                        ]
                    },
                    Menu {
                        text: ##[menu.options]"Options"
                        items: [
                            Menu {
                                text: ##[color_format]"Color Format"
                                items: for (formatter in ColorFormatter.formatters) {
                                    RadioMenuItem {
                                        action: itemMenuFormatSelected
                                        text: formatter.description
                                        toggleGroup: formatGroup
                                    }
                                }
                            }
                            CheckMenuItem {
                                text: ##[enable_alpha]"Enable Tranparency"
                                selected: bind chbEnableAlpha.selected with inverse
                            }
                        ]
                    },
                    Menu {
                        def aboutName = ##[about.name]"Color Selector";
                        def aboutVersion = ##[about.version]"Version 1.0";
                        def aboutCopyright = ##[about.copyright]"(c)Rafael Afonso - 2011"
                        text: ##[menu.help]"Help"
                        items: [
                            MenuItem {
                                text: ##[menu.help.about]"About"
                                action: function(): Void {
                                    Alert.inform(##[about.title]"About", "{aboutName}\n{aboutVersion}\n{aboutCopyright}");
                                }
                            }
                        ]
                    }
                ]
            }

    function itemMenuFormatSelected(): Void {
        for (index in [0..(sizeof this.formatGroup.toggles)]) {
            if (this.formatGroup.toggles[index].selected) {
                this.cmbColorFormat.select(index);
                break;
            }
        }
    }

    public-read def rectangle: javafx.scene.shape.Rectangle = javafx.scene.shape.Rectangle {
                effect: Reflection {
                    topOpacity: 0.95
                }
                fill: bind this.currentColor
                height: bind Math.max((scene.height - menuBar.height - grid.height), (scene.height /2))
                layoutInfo: LayoutInfo {
                    hgrow: javafx.scene.layout.Priority.ALWAYS
                    vgrow: javafx.scene.layout.Priority.ALWAYS
                    vfill: true
                }
                onMouseClicked: function(event: MouseEvent): Void {
                    if (event.clickCount == 2) {
                        shuffleColors()
                    }
                }
                width: bind scene.width
            }

    public-read def lblTitleWebColor: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: titlesLayout
                onMouseClicked: webColorComponentMouseClick
                text: "{##[web_color]'Web Color'}:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
                textFill: bind labelColor(currentColor as Color)
            }

    public-read def txbColorFilter: TextBox = TextBox {
                action: filterWebColor
                columns: 12
                layoutInfo: LayoutInfo {
                    vpos: javafx.geometry.VPos.TOP
                }
                onKeyPressed: function(me: KeyEvent): Void {
                    filterWebColor()
                }
                onMouseClicked: webColorComponentMouseClick
                selectOnFocus: true
                text: ""
            }

    public-read def chbWebColors: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
                layoutInfo: LayoutInfo {
                    vpos: javafx.geometry.VPos.TOP
                }
                items: WebColor.values
                onMouseClicked: webColorComponentMouseClick
                tooltip: Tooltip {
                    text: "Cor pré-definiida pelo W3C."
                }
            }

    public-read def lblTitleColorValue: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: titlesLayout
                text: "{##[color_code]'Color Code'}:"
                           textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    public-read def txbColorValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
                editable: false
                font: Font {
                    name: "monospaced"
                    size: 10
                }
                layoutInfo: GridLayoutInfo {
                    vpos: javafx.geometry.VPos.TOP
                    hgrow: Priority.NEVER
             //       minWidth: bind 0.3 * scene.width
                }
                text: "rgb(255, 255, 255)"
            }

    public-read def lblTitleColorFormat: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: titlesLayout
                text: "{##[color_format]'Color Format'}:"
                           textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    public-read def cmbColorFormat: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
                layoutInfo: LayoutInfo {
                    vpos: javafx.geometry.VPos.TOP
                }
                items: ColorFormatter.formatters
            }

    public-read def chbEnableAlpha: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
                layoutInfo: GridLayoutInfo {
                    hspan: 2
                    vpos: javafx.geometry.VPos.TOP
                }
                text: ##[enable_alpha]"Enable Tranparency"
            }

    public-read def grid: com.javafx.preview.layout.Grid = com.javafx.preview.layout.Grid {
                layoutInfo: LayoutInfo {
                    //                    height: bind panelsHeight
                    vfill: false
                    vgrow: Priority.NEVER
                }
                hgap: 6.0
                rows: [
                    gridWebColor = com.javafx.preview.layout.GridRow {
                                cells: [this.sliderControlRed.node, lblTitleWebColor, containerWebColors,]
                            }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlGreen.node, lblTitleColorValue, txbColorValue,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlBlue.node, lblTitleColorFormat, cmbColorFormat,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlAlpha.node, chbEnableAlpha,]
                    }
                ]
                vgap: 6.0
            }

    public-read def verticalBox: javafx.scene.layout.VBox = javafx.scene.layout.VBox {
                layoutX: 0.0
                layoutY: 0.0
                layoutInfo: LayoutInfo {
                    width: bind scene.width
                    height: bind scene.height
                }
                content: [menuBar, rectangle, grid,]
                spacing: 6.0
            }

    public function getDesignRootNodes(): javafx.scene.Node[] {
        [verticalBox,]
    }

    public-read def scene: javafx.scene.Scene = javafx.scene.Scene {
                width: 600.0
                height: 500.0
                content: getDesignRootNodes()
            }

    public function getDesignScene(): javafx.scene.Scene {
        scene
    }

    function webColorComponentMouseClick(me: MouseEvent): Void {
        if (me.clickCount == 2) {
            swapWebColorComponent();
        }
    }

    function swapWebColorComponent(): Void {
        if (this.visibleControlWebColor == this.chbWebColors) {
            this.visibleControlWebColor = this.txbColorFilter
        } else {
            this.visibleControlWebColor = this.chbWebColors
        }
    }

    /*bound */
    function labelColor(color: Color): Paint {
        if (color.opacity < 0.5) {
            Color.BLACK
        } else if ((color.red
                + color.green + color.blue) < 1.5) {
            Color.WHITE
        } else {
            Color.BLACK
        }
    }

    function filterWebColor(): Void {
        def pattern = this.txbColorFilter.text.toUpperCase();

        if (pattern == null or pattern.length() == 0) {
            this.selectedWebColors = WebColor.values;
        } else {
            this.selectedWebColors = WebColor.values[webColor | webColor.name.indexOf(pattern) >= 0];
        }
    }

    function formatColor(): Void {
        this.txbColorValue.text = currentFormatter.format(this.currentColor as Color, not sliderControlAlpha.disable);
    }

    function syncronizeControl(source: SliderControl): Void {
        if (source.selected) {
            insert source into this.syncronizedControls;

            def size = sizeof this.syncronizedControls;
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

        def alpha = if (this.sliderControlAlpha.disable) 1.0 else (this.sliderControlAlpha.value / Utils.MAX);
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
            def webColor: WebColor = item as WebColor;
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
        title: ##[title]"Color Selector"
        scene: design.getDesignScene()
    }
}

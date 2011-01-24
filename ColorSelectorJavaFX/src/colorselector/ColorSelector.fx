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
import javafx.scene.control.Control;
import javafx.scene.Parent;
import javafx.animation.transition.FadeTransition;
import javafx.scene.layout.Priority;
import javafx.scene.Cursor;

/**
 * @author rafael
 */
public class ColorSelector {

    // VARIÁVEIS - INÍCIO

    var width1 = 100;

    var controlsWidht = bind 0.5 * scene.width;

    var syncronizedControls: SliderControl[] = [];

    var visibleControlWebColor: Control;

    var filterPattern = bind this.txbColorFilter.text.toUpperCase();

    var selectedFilter = bind ((filterPattern != null) and (filterPattern.length() > 0));

    var selectedWebColors: Object[] = bind if (selectedFilter) WebColor.values[webColor | (webColor.name.indexOf(filterPattern) >= 0) or not webColor.defined] else WebColor.values
            on replace {
                handleChbWebColors();
                this.scene.cursor = Cursor.DEFAULT;
            }
    /*
    on invalidate {
    this.scene.cursor = Cursor.WAIT;
    }
     */

    var formatGroup = ToggleGroup {}

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

    // VARIÁVEIS - FINAL

    /**
     * Construtor
     */
    init {
        changeColors(null);
        this.visibleControlWebColor = this.chbWebColors;
        this.txbColorFilter.opacity = 0.0;
    }

    // FUNÇÕES - INÍCIO

    function itemMenuFormatSelected(): Void {
        for (index in [0..(sizeof this.formatGroup.toggles)]) {
            if (this.formatGroup.toggles[index].selected) {
                this.cmbColorFormat.select(index);
                break;
            }
        }
    }

    function swapWebColorComponent(): Void {
        var transition = FadeTransition {
                    fromValue: 1.0
                    toValue: 0.0
                    duration: 0.5s
                    node: bind this.visibleControlWebColor
                }
        transition.play();

        this.visibleControlWebColor = if (this.visibleControlWebColor == this.chbWebColors) {
                    this.txbColorFilter
                } else {
                    this.chbWebColors
                }

        transition.fromValue = 0.0;
        transition.toValue = 1.0;
        transition.play();
    }

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

    // FUNÇÕES - FINAL

    // COMPONENTES - INÍCIO

    def titlesLayout = LayoutInfo {
                hpos: javafx.geometry.HPos.RIGHT
                hfill: true
                hgrow: Priority.SOMETIMES
                minWidth: width1
                vpos: javafx.geometry.VPos.TOP
                width: width1
            }

    def controlsLayout = LayoutInfo {
        vpos: javafx.geometry.VPos.TOP
        hgrow: Priority.NEVER
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
                                text: bind if (visibleControlWebColor == chbWebColors) ##[menu.file.webcolorcontrol.goto.text]"Go to filter" else ##[menu.file.webcolorcontrol.goto.combo]"Go to selector"
                                action: swapWebColorComponent
                            }
                            MenuItem {
                                text: ##[menu.file.webcolorcontrol.clean]"Clean Filter"
                                action: function(): Void {
                                    this.txbColorFilter.text = null;
                                    if (this.visibleControlWebColor == this.txbColorFilter) {
                                        swapWebColorComponent();
                                    }
                                }
                                disable: bind not this.selectedFilter
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
                        text: ##[menu.help]"Help"
                        items: [
                            MenuItem {
                                text: ##[menu.help.about]"About"
                                action: function(): Void {
                                    def aboutName = ##[about.name]"Color Selector";
                                    def aboutVersion = ##[about.version]"Version 1.0";
                                    def aboutCopyright = ##[about.copyright]"(c)Rafael Afonso - 2011";

                                    Alert.inform(##[about.title]"About", "{aboutName}\n{aboutVersion}\n{aboutCopyright}");
                                }
                            }
                        ]
                    }
                ]
            }

    public-read def rectangle: javafx.scene.shape.Rectangle = javafx.scene.shape.Rectangle {
                effect: Reflection {
                    topOpacity: 0.95
                }
                fill: bind this.currentColor
                height: bind Math.max((scene.height - menuBar.height - grid.height), (scene.height / 3))
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

    public-read def lblTitleWebColor: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: titlesLayout
                onMouseClicked: function(me: MouseEvent): Void {
                    if (me.clickCount == 2) {
                        swapWebColorComponent();
                    }
                }
                text: "{##[web_color]'Web Color'}:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
                textFill: bind labelColor(currentColor as Color)
            }

    public-read def txbColorFilter: TextBox = TextBox {
                action: swapWebColorComponent
                columns: 12
                layoutInfo: controlsLayout
                selectOnFocus: true
                text: ""
            }

    public-read def chbWebColors: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
                items: bind selectedWebColors
                layoutInfo: controlsLayout
                tooltip: Tooltip {
                    text: "Cor pré-definiida pelo W3C."
                }
            }

    var containerWebColors: Parent = javafx.scene.layout.Flow {
                content: bind visibleControlWebColor
                nodeVPos: javafx.geometry.VPos.TOP
                nodeHPos: javafx.geometry.HPos.RIGHT
                layoutInfo: controlsLayout
            };

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

    public-read def lblTitleColorValue: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: titlesLayout
                text: "{##[color_code]'Color Code'}:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    public-read def txbColorValue: javafx.scene.control.TextBox = javafx.scene.control.TextBox {
                columns: 10
                editable: false
                font: Font {
                    name: "monospaced"
                    size: 10
                }
                layoutInfo: controlsLayout
                text: "rgb(255, 255, 255)"
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

    public-read def lblTitleColorFormat: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: titlesLayout
                text: "{##[color_format]'Color Format'}:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    public-read def cmbColorFormat: javafx.scene.control.ChoiceBox = javafx.scene.control.ChoiceBox {
                layoutInfo: controlsLayout
                items: ColorFormatter.formatters
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

    public-read def lblTitleEnableAlpha: javafx.scene.control.Label = javafx.scene.control.Label {
                layoutInfo: titlesLayout
                text: "{##[enable_alpha]'Enable Tranparency'}:"
                textAlignment: javafx.scene.text.TextAlignment.RIGHT
            }

    public-read def chbEnableAlpha: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
                layoutInfo: controlsLayout
            }

    public-read def grid: com.javafx.preview.layout.Grid = com.javafx.preview.layout.Grid {
                layoutInfo: LayoutInfo {
                    vfill: false
                    vgrow: Priority.NEVER
                }
                hgap: 6.0
                rows: [
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlRed.node, lblTitleWebColor, containerWebColors,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlGreen.node, lblTitleColorValue, txbColorValue,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlBlue.node, lblTitleColorFormat, cmbColorFormat,]
                    }
                    com.javafx.preview.layout.GridRow {
                        cells: [this.sliderControlAlpha.node, lblTitleEnableAlpha, chbEnableAlpha,]
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

    public-read def scene: javafx.scene.Scene = javafx.scene.Scene {
                width: 600.0
                height: 500.0
                content: verticalBox
            }

    // COMPONENTES - FINAL

}

function run(): Void {
    var design = ColorSelector {};

    javafx.stage.Stage {
        title: ##[title]"Color Selector"
        scene: design.scene
    }
}

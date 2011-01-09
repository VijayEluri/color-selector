/*
 * SliderControl.fx
 *
 * Created on 11/12/2010, 20:48:52
 */
package colorselector;

import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.input.KeyCode;
import javafx.scene.paint.Color;

/**
 * @author rafael
 */
public class SliderControl {

    def insets = Insets { left: 5.0, top: 0.0, right: 5.0, bottom: 0.0 };

    /**
     * Título do componente.
     */
    public var title: String = "";

    /**
     * Valor do componente
     */
    public var value: Number = Utils.MIN on replace {
                if (value < Utils.MIN) {
                    value = Utils.MIN;
                } else if (value > Utils.MAX) {
                    value = Utils.MAX;
                }

                onChange();
            };

    /**
     * Se o componente está selecionado ou não.
     */
    public var selected: Boolean = false on replace {
                onSelect();
            }

    /**
     * Se o componente está desabilitado ou não.
     */
    public var disable: Boolean = false on replace {
                onDisable();
            }

    public var width: Number = 468.0;

    public var height: Number = 60.0;

    public var backgroundColor: Color = Color.WHITE;

    public var foregroundColor: Color = Color.BLACK;

    var cssBackground = bind "-fx-background-color: rgb({Utils.colorValueToInt(this.backgroundColor.red)}, {Utils.colorValueToInt(this.backgroundColor.green)}, {Utils.colorValueToInt(this.backgroundColor.blue)})";

    // TODO: Como alterar a cor da fonte das marcas do Slider?
    var cssForeground = bind "-fx-text-fill: rgb({Utils.colorValueToInt(this.foregroundColor.red)}, {Utils.colorValueToInt(this.foregroundColor.green)}, {Utils.colorValueToInt(this.foregroundColor.blue)})";

    var cssControls = bind "{cssForeground}; -fx-background-color: transparent;";

    public var onChange: function(): Void = function() {
            }

    public var onDisable: function(): Void = function() {
            }

    public var onSelect: function(): Void = function() {
            }

    def extendedStep = 25;
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:main
    public-read def rectangle: javafx.scene.shape.Rectangle = javafx.scene.shape.Rectangle {
        fill: bind backgroundColor
        width: bind stack.width
        height: bind stack.height
    }
    
    def __layoutInfo_chbSelected: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        hfill: false
        vpos: javafx.geometry.VPos.TOP
        margin: getMarginDefault()
    }
    public-read def chbSelected: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
        layoutInfo: __layoutInfo_chbSelected
        style: bind cssControls
        onMouseWheelMoved: handleMouseWheelMoved
        text: ""
        selected: bind selected with inverse
    }
    
    def __layoutInfo_lblTitle: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        vpos: javafx.geometry.VPos.TOP
        margin: getMarginDefault()
    }
    public-read def lblTitle: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblTitle
        style: bind cssControls
        onMouseWheelMoved: handleMouseWheelMoved
        text: bind title with inverse
    }
    
    def __layoutInfo_sldValue: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: sldValueWidth ()
        hfill: true
        vpos: javafx.geometry.VPos.TOP
        hgrow: javafx.scene.layout.Priority.ALWAYS
        hshrink: javafx.scene.layout.Priority.ALWAYS
        margin: getMarginDefault()
    }
    public-read def sldValue: javafx.scene.control.Slider = javafx.scene.control.Slider {
        layoutInfo: __layoutInfo_sldValue
        style: bind cssControls
        onKeyPressed: sldValueOnKeyPressed
        onMousePressed: null
        onMouseWheelMoved: handleMouseWheelMoved
        min: sldValueMin ()
        max: sldValueMax ()
        value: bind value with inverse
        clickToPosition: false
        majorTickUnit: 50.0
        minorTickCount: 5
        showTickLabels: true
        showTickMarks: true
        snapToTicks: true
        labelFormatter: sldValueLabelFormatter
    }
    
    def __layoutInfo_lblValue: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: 30.0
        vpos: javafx.geometry.VPos.TOP
        margin: getMarginDefault()
    }
    public-read def lblValue: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblValue
        style: bind cssControls
        onMouseWheelMoved: handleMouseWheelMoved
        text: bind "{%03.0f sldValue.value}"
    }
    
    def __layoutInfo_hrbSliderControl: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width with inverse
        height: bind height
        hfill: true
        vfill: false
        hgrow: javafx.scene.layout.Priority.ALWAYS
        hshrink: javafx.scene.layout.Priority.ALWAYS
        margin: javafx.geometry.Insets { left: 5.0, top: 5.0, right: 0.0, bottom: 0.0 }
    }
    public-read def hrbSliderControl: javafx.scene.layout.HBox = javafx.scene.layout.HBox {
        disable: bind disable with inverse
        layoutX: 0.0
        layoutY: 0.0
        layoutInfo: __layoutInfo_hrbSliderControl
        onMousePressed: null
        onMouseWheelMoved: handleMouseWheelMoved
        content: [ chbSelected, lblTitle, sldValue, lblValue, ]
        spacing: 6.0
        vpos: javafx.geometry.VPos.BASELINE
    }
    
    def __layoutInfo_stack: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: bind width with inverse
        height: bind height
        minHeight: 60.0
    }
    public-read def stack: javafx.scene.layout.Stack = javafx.scene.layout.Stack {
        layoutInfo: __layoutInfo_stack
        content: [ rectangle, hrbSliderControl, ]
    }
    
    public-read def currentState: org.netbeans.javafx.design.DesignState = org.netbeans.javafx.design.DesignState {
    }
    
    public function getDesignRootNodes (): javafx.scene.Node[] {
        [ stack, ]
    }
    // </editor-fold>//GEN-END:main

    function changeValue(increment: Integer, delta: Number): Void {
        this.value = increment * delta + this.value;
    }

    function sldValueOnKeyPressed (event: javafx.scene.input.KeyEvent): Void {
        if(((event.code == KeyCode.VK_LEFT) or (event.code == KeyCode.VK_RIGHT)) and event.controlDown) {
            def increment = if(event.code == KeyCode.VK_RIGHT) then 1 else -1;
            this.changeValue(increment, extendedStep);
        } else if((event.code == KeyCode.VK_UP) or (event.code == KeyCode.VK_PAGE_UP)) {
            var step = if(event.controlDown) then extendedStep else 1;
            this.changeValue(1, step);
        } else if((event.code == KeyCode.VK_DOWN) or (event.code == KeyCode.VK_PAGE_DOWN)) {
            var step = if(event.controlDown) then extendedStep else 1;
            this.changeValue(-1, step);
        }
    }

    function handleMouseWheelMoved(event: javafx.scene.input.MouseEvent): Void {
        def increment = if(event.wheelRotation > 0) then -1 else 1;
        def delta = if(event.controlDown or event.secondaryButtonDown) then extendedStep else 1;
        this.changeValue(increment, delta);
    }

    function sldValueMax (): Number {
        Utils.MAX
    }

    function sldValueMin (): Number {
        Utils.MIN
    }

    function sldValueWidth (): Number {
        0.0
    }

    function getMarginDefault (): javafx.geometry.Insets {
        insets
    }

    function sldValueLabelFormatter(value: Number): String {
        "{%3.0f value}"
    }

    public def node: Node = this.stack;
}

function run (): Void {
    var design = SliderControl {};

    javafx.stage.Stage {
        title: "SliderControl"
        scene: javafx.scene.Scene {
            content: design.getDesignRootNodes ()
        }
    }
}

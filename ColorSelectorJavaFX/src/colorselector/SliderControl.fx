/*
 * SliderControl.fx
 *
 * Created on 11/12/2010, 20:48:52
 */
package colorselector;

import javafx.geometry.Insets;

/**
 * @author rafael
 */
public class SliderControl {

    def insets = Insets { left: 5.0, top: 0.0, right: 5.0, bottom: 0.0 };
    
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:main
    def __layoutInfo_chbSelectes: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        hfill: false
        margin: getMarginDefault()
    }
    public-read def chbSelectes: javafx.scene.control.CheckBox = javafx.scene.control.CheckBox {
        layoutInfo: __layoutInfo_chbSelectes
        text: ""
    }
    
    def __layoutInfo_lblTitle: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        margin: getMarginDefault()
    }
    public-read def lblTitle: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblTitle
        text: "XXX"
    }
    
    def __layoutInfo_sldValue: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: sldValueWidth ()
        hfill: true
        hgrow: javafx.scene.layout.Priority.ALWAYS
        hshrink: javafx.scene.layout.Priority.ALWAYS
        margin: getMarginDefault()
    }
    public-read def sldValue: javafx.scene.control.Slider = javafx.scene.control.Slider {
        layoutInfo: __layoutInfo_sldValue
        max: 255.0
        value: 50.0
        majorTickUnit: 50.0
        minorTickCount: 5
        showTickLabels: true
        showTickMarks: true
        snapToTicks: true
        labelFormatter: sldValueLabelFormatter
    }
    
    def __layoutInfo_lblValue: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        margin: getMarginDefault()
    }
    public-read def lblValue: javafx.scene.control.Label = javafx.scene.control.Label {
        layoutInfo: __layoutInfo_lblValue
        text: bind "{%03.0f sldValue.value}"
    }
    
    def __layoutInfo_hrbSliderControl: javafx.scene.layout.LayoutInfo = javafx.scene.layout.LayoutInfo {
        width: 468.0
        height: 60.0
        hfill: true
        vfill: false
        hgrow: javafx.scene.layout.Priority.ALWAYS
        hshrink: javafx.scene.layout.Priority.ALWAYS
    }
    public-read def hrbSliderControl: javafx.scene.layout.HBox = javafx.scene.layout.HBox {
        layoutInfo: __layoutInfo_hrbSliderControl
        content: [ chbSelectes, lblTitle, sldValue, lblValue, ]
        spacing: 6.0
        vpos: javafx.geometry.VPos.BASELINE
    }
    
    public-read def currentState: org.netbeans.javafx.design.DesignState = org.netbeans.javafx.design.DesignState {
    }
    
    public function getDesignRootNodes (): javafx.scene.Node[] {
        [ hrbSliderControl, ]
    }
    // </editor-fold>//GEN-END:main

    function sldValueWidth (): Number {
        0.0
    }

    function getMarginDefault (): javafx.geometry.Insets {
        insets
    }

    function sldValueLabelFormatter(value: Number): String {
        "{%3.0f value}"
    }

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

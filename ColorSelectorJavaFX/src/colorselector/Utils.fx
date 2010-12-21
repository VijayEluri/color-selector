/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package colorselector;

public def MIN: Integer = 0;

public def MAX: Integer = 255;

public function colorValueToInt(value: Number): Integer {
    (value * MAX) as Integer
}

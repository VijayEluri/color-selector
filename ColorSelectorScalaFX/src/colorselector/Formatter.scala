package colorselector

import scalafx.scene.paint.Color
import scalafx.util.StringConverter

object Formatter {
  val formatters = List(HexFormatter, RgbFormatter)

  val formatterConverter = new StringConverter[Formatter] {
    def fromString(string: String) = sys.error("")
    def toString(f: Formatter): String = f.description
  }
}

abstract sealed case class Formatter(val description: String) {

  private def doubleToInt(d: Double) = (colorselector.Max * d).toInt

  protected def colorToRgbInt(c: Color): (Int, Int, Int) =
    (doubleToInt(c.red), doubleToInt(c.green), doubleToInt(c.blue))

  protected def formatWithAlpha(c: Color): String

  protected def formatWithoutAlpha(c: Color): String

  def format(c: Color, hasAlpha: Boolean): String =
    if (hasAlpha) formatWithAlpha(c) else formatWithoutAlpha(c)

}

object HexFormatter extends Formatter("Hexadecimal") {
  val HEXADECIMAL_FORMAT = "#%02x%02x%02x";

  def formatWithAlpha(c: Color): String = {
    val (r, g, b) = super.colorToRgbInt(c)
    HEXADECIMAL_FORMAT.format(r, g, b).toUpperCase
  }

  def formatWithoutAlpha(c: Color): String = formatWithAlpha(c)

}

object RgbFormatter extends Formatter("RGB") {
  val RGB_FORMAT = "rgb(%3d, %3d, %3d)"
  val RGBA_FORMAT = "rgba(%3d, %3d, %3d, %.2f)"

  def formatWithAlpha(c: Color): String = {
    val (r, g, b) = super.colorToRgbInt(c)
    RGB_FORMAT.format(r, g, b)
  }

  def formatWithoutAlpha(c: Color): String = {
    val (r, g, b) = super.colorToRgbInt(c)
    RGBA_FORMAT.format(r, g, b, c.opacity)
  }

}


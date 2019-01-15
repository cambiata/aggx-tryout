//----------------------------------------------------------------------------
// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)
//
// Permission to copy, use, modify, sell and distribute this software
// is granted provided this copyright notice appears in all copies.
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//
// Haxe port by: Hypeartist hypeartist@gmail.com
// Copyright (C) 2011 https://code.google.com/p/aggx
//
//----------------------------------------------------------------------------
// Contact: mcseem@antigrain.com
//          mcseemagg@yahoo.com
//          http://www.antigrain.com
//----------------------------------------------------------------------------
package aggx.renderer;

// =======================================================================================================
import aggx.core.memory.MemoryUtils;
import aggx.color.RgbaColor;
import aggx.rasterizer.IScanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.core.memory.MemoryReader;

using aggx.core.memory.MemoryReader;

// =======================================================================================================
class SolidScanlineRenderer implements IRenderer {
	private var _clippingRenderer:ClippingRenderer;
	private var _color:RgbaColor;

	//---------------------------------------------------------------------------------------------------
	public function new(clipRen:ClippingRenderer) {
		_clippingRenderer = clipRen;
		_color = new RgbaColor();
	}

	//---------------------------------------------------------------------------------------------------
	public function attach(clipRen:ClippingRenderer) {
		_clippingRenderer = clipRen;
	}

	//---------------------------------------------------------------------------------------------------
	private inline function get_color():RgbaColor {
		return _color;
	}

	private inline function set_color(value:RgbaColor):RgbaColor {
		return _color = value;
	}

	public var color(get, set):RgbaColor;

	//---------------------------------------------------------------------------------------------------
	public function prepare():Void {}

	//---------------------------------------------------------------------------------------------------
	public inline function render(sl:IScanline):Void {
		renderAASolidScanline(sl, _clippingRenderer, _color);
	}

	//---------------------------------------------------------------------------------------------------
	public static function renderAASolidScanline(sl:IScanline, render:ClippingRenderer, color:RgbaColor):Void {
		var y = sl.y;
		var numSpans = sl.spanCount;
		var spanIterator = sl.spanIterator;

		while (true) {
			var span = spanIterator.current;
			var x = span.x;
			if (span.len > 0) {
				render.blendSolidHSpan(x, y, span.len, color, span.getCovers());
			} else {
				render.blendHLine(x, y, (x - span.len - 1), color, span.getCovers().readUInt8());
			}
			if (--numSpans == 0)
				break;
			spanIterator.next();
		}
	}

	//---------------------------------------------------------------------------------------------------
	public static function renderAASolidScanlines(ras:ScanlineRasterizer, sl:IScanline, ren:ClippingRenderer, color:RgbaColor):Void {
		if (ras.rewindScanlines()) {
			var renColor = color;

			sl.reset(ras.minX, ras.maxX);
			while (ras.sweepScanline(sl)) {
				var y = sl.y;
				var num_spans = sl.spanCount;
				var spanIterator = sl.spanIterator;

				while (true) {
					var span = spanIterator.current;
					var x = span.x;
					if (span.len > 0) {
						ren.blendSolidHSpan(x, y, span.len, renColor, span.getCovers());
					} else {
						ren.blendHLine(x, y, (x - span.len - 1), renColor, span.getCovers().readUInt8());
					}
					if (--num_spans == 0)
						break;
					spanIterator.next();
				}
			}
		}
	}

	//---------------------------------------------------------------------------------------------------
	public static function renderScanlines(ras:ScanlineRasterizer, sl:IScanline, ren:IRenderer):Void {
		if (ras.rewindScanlines()) {
			sl.reset(ras.minX, ras.maxX);
			ren.prepare();
			while (ras.sweepScanline(sl)) {
				ren.render(sl);
			}
		}
	}
}

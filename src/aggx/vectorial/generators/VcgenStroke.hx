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
package aggx.vectorial.generators;

// =======================================================================================================
import aggx.vectorial.IVertexSource;
import aggx.vectorial.MathStroke;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathFlags;
import aggx.vectorial.PathUtils;
import aggx.vectorial.VertexDistance;
import aggx.vectorial.VertexSequence;
import aggx.core.geometry.Coord;
import aggx.core.memory.Ref;

// =======================================================================================================
class VcgenStroke implements ICurveGenerator implements IVertexSource // Vertex Curve Generator
{
	inline private static var INITIAL = 0;
	inline private static var READY = 1;
	inline private static var CAP1 = 2;
	inline private static var CAP2 = 3;
	inline private static var OUTLINE1 = 4;
	inline private static var CLOSE_FIRST = 5;
	inline private static var OUTLINE2 = 6;
	inline private static var OUT_VERTICES = 7;
	inline private static var END_POLY1 = 8;
	inline private static var END_POLY2 = 9;
	inline private static var STOP = 10;

	//---------------------------------------------------------------------------------------------------
	private var _stroker:MathStroke;
	private var _srcVertices:VertexSequence;
	private var _outVertices:Array<Coord>;
	private var _shorten:Float;
	private var _isClosed:UInt;
	private var _status:Int;
	private var _prevStatus:Int;
	private var _srcVertexIndex:Int;
	private var _outVertexIndex:Int;

	//---------------------------------------------------------------------------------------------------
	public function new() {
		_stroker = new MathStroke();
		_srcVertices = new VertexSequence();
		_outVertices = new Array();
		_outVertexIndex = 0;
		_srcVertexIndex = 0;
		_status = INITIAL;
		_isClosed = 0;
		_shorten = 0.0;
	}

	//---------------------------------------------------------------------------------------------------
	private inline function get_width():Float {
		return _stroker.width;
	}

	private inline function set_width(value:Float):Float {
		return _stroker.width = value;
	}

	public var width(get, set):Float;

	//---------------------------------------------------------------------------------------------------
	private inline function get_lineCap():Int {
		return _stroker.lineCap;
	}

	private inline function set_lineCap(value:Int):Int {
		return _stroker.lineCap = value;
	}

	public var lineCap(get, set):Int;

	//---------------------------------------------------------------------------------------------------
	private inline function get_lineJoin():Int {
		return _stroker.lineJoin;
	}

	private inline function set_lineJoin(value:Int):Int {
		return _stroker.lineJoin = value;
	}

	public var lineJoin(get, set):Int;

	//---------------------------------------------------------------------------------------------------
	private inline function get_innerJoin():Int {
		return _stroker.innerJoin;
	}

	private inline function set_innerJoin(value:Int):Int {
		return _stroker.innerJoin = value;
	}

	public var innerJoin(get, set):Int;

	//---------------------------------------------------------------------------------------------------
	private inline function get_miterLimit():Float {
		return _stroker.miterLimit;
	}

	private inline function set_miterLimit(value:Float):Float {
		return _stroker.miterLimit = value;
	}

	public var miterLimit(get, set):Float;

	//---------------------------------------------------------------------------------------------------
	private inline function get_innerMiterLimit():Float {
		return _stroker.innerMiterLimit;
	}

	private inline function set_innerMiterLimit(value:Float):Float {
		return _stroker.innerMiterLimit = value;
	}

	public var innerMiterLimit(get, set):Float;

	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float {
		return _stroker.approximationScale;
	}

	private inline function set_approximationScale(value:Float):Float {
		return _stroker.approximationScale = value;
	}

	public var approximationScale(get, set):Float;

	//---------------------------------------------------------------------------------------------------
	private inline function set_miterLimitTheta(value:Float):Float {
		return _stroker.miterLimit = value;
	}

	public var miterLimitTheta(null, set):Float;

	//---------------------------------------------------------------------------------------------------
	private inline function get_shorten():Float {
		return _shorten;
	}

	private inline function set_shorten(value:Float):Float {
		return _shorten = value;
	}

	public var shorten(get, set):Float;

	//---------------------------------------------------------------------------------------------------
	public function removeAll() {
		_srcVertices.removeAll();
		_isClosed = 0;
		_status = INITIAL;
	}

	//---------------------------------------------------------------------------------------------------
	public inline function addVertex(x:Float, y:Float, cmd:UInt):Void {
		_status = INITIAL;
		if (PathUtils.isMoveTo(cmd)) {
			_srcVertices.modifyLast(new VertexDistance(x, y));
		} else {
			if (PathUtils.isVertex(cmd)) {
				_srcVertices.add(new VertexDistance(x, y));
			} else {
				_isClosed = PathUtils.getCloseFlag(cmd);
			}
		}
	}

	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void {
		if (_status == INITIAL) {
			_srcVertices.close(_isClosed != 0);
			PathUtils.shortenPath(_srcVertices, _shorten, _isClosed);
			if (_srcVertices.size < 3)
				_isClosed = 0;
		}
		_status = READY;
		_srcVertexIndex = 0;
		_outVertexIndex = 0;
	}

	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt {
		var cmd = PathCommands.LINE_TO;
		while (!PathUtils.isStop(cmd)) {
			switch (_status) {
				case INITIAL:
					rewind(0);
					_status = READY;
				case READY:
					if (_srcVertices.size < (2 + (_isClosed != 0 ? 1 : 0))) {
						cmd = PathCommands.STOP;
					} else {
						_status = _isClosed != 0 ? OUTLINE1 : CAP1;
						cmd = PathCommands.MOVE_TO;
						_srcVertexIndex = 0;
						_outVertexIndex = 0;
					}

				case CAP1:
					#if cs
					_outVertices = [];
					#end
					_stroker.calcCap(_outVertices, _srcVertices.get(0), _srcVertices.get(1), _srcVertices.get(0).dist);
					_srcVertexIndex = 1;
					_prevStatus = OUTLINE1;
					_status = OUT_VERTICES;
					_outVertexIndex = 0;

				case CAP2:
					#if cs
					_outVertices = [];
					#end
					_stroker.calcCap(_outVertices, _srcVertices.get(_srcVertices.size - 1), _srcVertices.get(_srcVertices.size - 2),
						_srcVertices.get(_srcVertices.size - 2).dist);
					_prevStatus = OUTLINE2;
					_status = OUT_VERTICES;
					_outVertexIndex = 0;

				case OUTLINE1:
					var proceed = true;
					if (_isClosed != 0) {
						if (_srcVertexIndex >= _srcVertices.size) {
							_prevStatus = CLOSE_FIRST;
							_status = END_POLY1;
							proceed = false;
						}
					} else {
						if (_srcVertexIndex >= (_srcVertices.size - 1)) {
							_status = CAP2;
							proceed = false;
						}
					}
					if (proceed) {
						#if cs
						_outVertices = [];
						#end
						_stroker.calcJoin(_outVertices, _srcVertices.prev(_srcVertexIndex), _srcVertices.curr(_srcVertexIndex),
							_srcVertices.next(_srcVertexIndex), _srcVertices.prev(_srcVertexIndex).dist, _srcVertices.curr(_srcVertexIndex).dist);
						++_srcVertexIndex;
						_prevStatus = _status;
						_status = OUT_VERTICES;
						_outVertexIndex = 0;
					}

				case CLOSE_FIRST:
					_status = OUTLINE2;
					cmd = PathCommands.MOVE_TO;

				case OUTLINE2:
					if (_srcVertexIndex <= (_isClosed == 0 ? 1 : 0)) {
						_status = END_POLY2;
						_prevStatus = STOP;
					} else {
						--_srcVertexIndex;
						#if cs
						_outVertices = [];
						#end
						_stroker.calcJoin(_outVertices, _srcVertices.next(_srcVertexIndex), _srcVertices.curr(_srcVertexIndex),
							_srcVertices.prev(_srcVertexIndex), _srcVertices.curr(_srcVertexIndex).dist, _srcVertices.prev(_srcVertexIndex).dist);

						_prevStatus = _status;
						_status = OUT_VERTICES;
						_outVertexIndex = 0;
					}

				case OUT_VERTICES:
					if (_outVertexIndex >= _outVertices.length) {
						_status = _prevStatus;
					} else {
						var c = _outVertices[_outVertexIndex++];
						x.value = c.x;
						y.value = c.y;
						return cmd;
					}

				case END_POLY1:
					_status = _prevStatus;
					return PathCommands.END_POLY | PathFlags.CLOSE | PathFlags.CCW;

				case END_POLY2:
					_status = _prevStatus;
					return PathCommands.END_POLY | PathFlags.CLOSE | PathFlags.CW;

				case STOP:
					cmd = PathCommands.STOP;
			}
		}
		return cmd;
	}
}

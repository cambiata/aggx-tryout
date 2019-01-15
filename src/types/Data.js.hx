/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package types;

import types.DataType;
import js.html.DataView;
import types.DataType;
import js.html.ArrayBuffer;
import js.html.ArrayBufferView;
import js.html.Int8Array;
import js.html.Uint8Array;
import js.html.Int16Array;
import js.html.Uint16Array;
import js.html.Int32Array;
import js.html.Uint32Array;
import js.html.Float32Array;
import js.html.Float64Array;

// import js.html.StringView;
class Data {
	inline static public var SIZE_OF_INT8:Int = 1;
	inline static public var SIZE_OF_UINT8:Int = 1;
	inline static public var SIZE_OF_INT16:Int = 2;
	inline static public var SIZE_OF_UINT16:Int = 2;
	inline static public var SIZE_OF_INT32:Int = 4;
	inline static public var SIZE_OF_UINT32:Int = 4;
	inline static public var SIZE_OF_FLOAT32:Int = 4;
	inline static public var SIZE_OF_FLOAT64:Int = 8;

	private var _offset:Int = 0;
	private var _offsetLength:Int = 0;
	private var _allocedLength:Int = 0;

	public var allocedLength(get, never):Int;

	private function get_allocedLength():Int {
		return _allocedLength;
	}

	public var offset(get, set):Int;

	private function set_offset(value:Int):Int {
		if (value == null)
			_offset = 0;
		else
			_offset = value;

		return _offset;
	}

	private function get_offset():Int {
		return _offset;
	}

	public var offsetLength(get, set):Int;

	private function set_offsetLength(value:Int):Int {
		_offsetLength = value;

		return _offsetLength;
	}

	private function get_offsetLength():Int {
		return _offsetLength;
	}

	public function resetOffset():Void {
		_offset = 0;
		_offsetLength = allocedLength;
	}

	public var arrayBuffer(default, set):ArrayBuffer;
	public var int8Array:Int8Array = null;
	public var uint8Array:Uint8Array = null;
	public var int16Array:Int16Array = null;
	public var uint16Array:Uint16Array = null;
	public var int32Array:Int32Array = null;
	public var uint32Array:Uint32Array = null;
	public var float32Array:Float32Array = null;
	public var float64Array:Float64Array = null;
	public var dataView:DataView = null;

	// public var stringView:StringView = null;
	public function new(sizeInBytes:Int):Void {
		if (sizeInBytes != 0) {
			_offsetLength = sizeInBytes;
			_offset = 0;
			set_arrayBuffer(new ArrayBuffer(sizeInBytes));
		}

		_allocedLength = sizeInBytes;
	}

	///for usage in html5 haxelibs
	public function set_arrayBuffer(value:ArrayBuffer):ArrayBuffer {
		arrayBuffer = value;
		_allocedLength = value.byteLength;

		_offsetLength = _allocedLength;
		_offset = 0;

		remakeViews();

		return value;
	}

	private function remakeViews():Void {
		var length = arrayBuffer.byteLength;

		int8Array = new Int8Array(arrayBuffer);
		uint8Array = new Uint8Array(arrayBuffer);
		// stringView = new StringView(arrayBuffer);

		var truncated2Mult:Int = Std.int((length - length % SIZE_OF_INT16) / SIZE_OF_INT16);
		int16Array = new Int16Array(arrayBuffer, 0, truncated2Mult);
		uint16Array = new Uint16Array(arrayBuffer, 0, truncated2Mult);

		var truncated4Mult:Int = Std.int((length - length % SIZE_OF_INT32) / SIZE_OF_INT32);
		int32Array = new Int32Array(arrayBuffer, 0, truncated4Mult);
		uint32Array = new Uint32Array(arrayBuffer, 0, truncated4Mult);
		float32Array = new Float32Array(arrayBuffer, 0, truncated4Mult);

		var truncated8Mult:Int = Std.int((length - length % SIZE_OF_FLOAT64) / SIZE_OF_FLOAT64);
		float64Array = new Float64Array(arrayBuffer, 0, truncated8Mult);

		dataView = new DataView(arrayBuffer);
	}

	public function writeData(data:Data):Void {
		var subarrayView = data.uint8Array.subarray(data._offset, data._offset + data._offsetLength);
		uint8Array.set(subarrayView, offset);
	}

	// Float write and read functions
	public function writeInt(value:Int, targetDataType:DataType):Void {
		switch (targetDataType) {
			case DataType.DataTypeInt8:
				writeInt8(value);
			case DataType.DataTypeUInt8:
				writeUInt8(value);
			case DataType.DataTypeInt16:
				writeInt16(value);
			case DataType.DataTypeUInt16:
				writeUInt16(value);
			case DataType.DataTypeInt32:
				writeInt32(value);
			case DataType.DataTypeUInt32:
				writeUInt32(value);
			case DataType.DataTypeFloat32:
				writeFloat32(value);
			case DataType.DataTypeFloat64:
				writeFloat64(value);
		}
	}

	public function writeIntArray(array:Array<Int>, dataType:DataType):Void {
		var dataSize = types.DataTypeUtils.dataTypeByteSize(dataType);

		var prevOffset = _offset;
		for (i in 0...array.length) {
			writeInt(array[i], dataType);
			_offset += dataSize;
		}
		_offset = prevOffset;
	}

	public function writeInt8(value:Int):Void {
		int8Array[_offset] = value;
	}

	public function writeUInt8(value:Int):Void {
		uint8Array[_offset] = value;
	}

	public function writeInt16(value:Int):Void {
		if (_offset % SIZE_OF_INT16 == 0)
			int16Array[Std.int(_offset / SIZE_OF_INT16)] = value;
		else
			dataView.setInt16(_offset, value, true);
	}

	public function writeUInt16(value:Int):Void {
		if (_offset % SIZE_OF_UINT16 == 0)
			uint16Array[Std.int(_offset / SIZE_OF_UINT16)] = value;
		else
			dataView.setUint16(_offset, value, true);
	}

	public function writeInt32(value:Int):Void {
		if (_offset % SIZE_OF_INT32 == 0)
			int32Array[Std.int(offset / SIZE_OF_INT32)] = value;
		else
			dataView.setInt32(_offset, value, true);
	}

	public function writeUInt32(value:Int):Void {
		if (_offset % SIZE_OF_UINT32 == 0)
			uint32Array[Std.int(_offset / SIZE_OF_UINT32)] = value;
		else
			dataView.setUint32(_offset, value, true);
	}

	public function readInt(targetDataType:DataType):Int {
		switch (targetDataType) {
			case DataType.DataTypeInt8:
				return readInt8();
			case DataType.DataTypeUInt8:
				return readUInt8();
			case DataType.DataTypeInt16:
				return readInt16();
			case DataType.DataTypeUInt16:
				return readUInt16();
			case DataType.DataTypeInt32:
				return readInt32();
			case DataType.DataTypeUInt32:
				return readUInt32();
			case DataType.DataTypeFloat32:
				return Std.int(readFloat32());
			case DataType.DataTypeFloat64:
				return Std.int(readFloat64());
		}
	}

	public function readIntArray(count:Int, dataType:DataType):Array<Int> {
		var dataSize = types.DataTypeUtils.dataTypeByteSize(dataType);

		var prevOffset = get_offset();
		var currentOffset = prevOffset;

		var array = new Array<Int>();
		for (i in 0...count) {
			set_offset(currentOffset);
			array.push(readInt(dataType));

			currentOffset += dataSize;
		}
		set_offset(prevOffset);
		return array;
	}

	public function readInt8():Int {
		return int8Array[_offset];
	}

	public function readUInt8():Int {
		return uint8Array[_offset];
	}

	public function readInt16():Int {
		if (_offset % SIZE_OF_INT16 == 0)
			return int16Array[Std.int(_offset / SIZE_OF_INT16)];
		else
			return dataView.getInt16(_offset, true);
	}

	public function readUInt16():Int {
		if (_offset % SIZE_OF_UINT16 == 0)
			return uint16Array[Std.int(_offset / SIZE_OF_UINT16)];
		else
			return dataView.getUint16(_offset, true);
	}

	public function readInt32():Int {
		if (_offset % SIZE_OF_INT32 == 0)
			return int32Array[Std.int(_offset / SIZE_OF_INT32)];
		else
			return dataView.getInt32(_offset, true);
	}

	public function readUInt32():Int {
		if (_offset % SIZE_OF_UINT32 == 0)
			return uint32Array[Std.int(_offset / SIZE_OF_UINT32)];
		else
			return dataView.getUint32(_offset, true);
	}

	// Float write and read functions
	public function writeFloat(value:Float, targetDataType:DataType):Void {
		switch (targetDataType) {
			case DataType.DataTypeInt8:
				writeInt8(Std.int(value));
			case DataType.DataTypeUInt8:
				writeUInt8(Std.int(value));
			case DataType.DataTypeInt16:
				writeInt16(Std.int(value));
			case DataType.DataTypeUInt16:
				writeUInt16(Std.int(value));
			case DataType.DataTypeInt32:
				writeInt32(Std.int(value));
			case DataType.DataTypeUInt32:
				writeUInt32(Std.int(value));
			case DataType.DataTypeFloat32:
				writeFloat32(value);
			case DataType.DataTypeFloat64:
				writeFloat64(value);
		}
	}

	public function writeFloatArray(array:Array<Float>, dataType:DataType):Void {
		var dataSize = types.DataTypeUtils.dataTypeByteSize(dataType);

		var prevOffset = _offset;
		for (i in 0...array.length) {
			writeFloat(array[i], dataType);
			_offset += dataSize;
		}
		_offset = prevOffset;
	}

	public function writeFloat32(value:Float):Void {
		if (_offset % SIZE_OF_FLOAT32 == 0)
			float32Array[Std.int(_offset / SIZE_OF_FLOAT32)] = value;
		else
			dataView.setFloat32(_offset, value, true);
	}

	public function writeFloat64(value:Float):Void {
		if (_offset % SIZE_OF_FLOAT64 == 0)
			float64Array[Std.int(_offset / SIZE_OF_FLOAT64)] = value;
		else
			dataView.setFloat64(_offset, value, true);
	}

	public function readFloat(targetDataType:DataType):Float {
		switch (targetDataType) {
			case DataType.DataTypeFloat32:
				return readFloat32();
			case DataType.DataTypeFloat64:
				return readFloat64();
			case DataType.DataTypeInt8:
				return readInt8();
			case DataType.DataTypeUInt8:
				return readUInt8();
			case DataType.DataTypeInt16:
				return readInt16();
			case DataType.DataTypeUInt16:
				return readUInt16();
			case DataType.DataTypeInt32:
				return readInt32();
			case DataType.DataTypeUInt32:
				return readUInt32();
		}
	}

	public function readFloatArray(count:Int, dataType:DataType):Array<Float> {
		var dataSize = types.DataTypeUtils.dataTypeByteSize(dataType);

		var prevOffset = get_offset();
		var currentOffset = prevOffset;

		var array = new Array<Float>();
		for (i in 0...count) {
			set_offset(currentOffset);
			array.push(readFloat(dataType));

			currentOffset += dataSize;
		}
		set_offset(prevOffset);
		return array;
	}

	public function readFloat32():Float {
		if (_offset % SIZE_OF_FLOAT32 == 0)
			return float32Array[Std.int(_offset / SIZE_OF_FLOAT32)];
		else
			return dataView.getFloat32(_offset, true);
	}

	public function readFloat64():Float {
		if (_offset % SIZE_OF_FLOAT64 == 0)
			return float64Array[Std.int(_offset / SIZE_OF_FLOAT64)];
		else
			return dataView.getFloat64(_offset, true);
	}

	public function toString(?dataType:DataType):String {
		if (dataType == null) {
			dataType = DataType.DataTypeInt32;
		}

		var output = "";
		output += "[";

		var view:Dynamic = null;

		switch (dataType) {
			case DataType.DataTypeInt8:
				view = int8Array;
			case DataType.DataTypeUInt8:
				view = uint8Array;
			case DataType.DataTypeInt16:
				view = uint16Array;
			case DataType.DataTypeUInt16:
				view = uint16Array;
			case DataType.DataTypeInt32:
				view = int32Array;
			case DataType.DataTypeUInt32:
				view = uint32Array;
			case DataType.DataTypeFloat32:
				view = float32Array;
			case DataType.DataTypeFloat64:
				view = float64Array;
		}

		var dataSize = DataTypeUtils.dataTypeByteSize(dataType);
		var count:Int = Std.int(arrayBuffer.byteLength / dataSize);

		if (count > 0) {
			output += view[0];
		}

		for (i in 1...count) {
			output += ", ";
			output += view[i];
		}

		output += "]";
		return output;
	}

	public function resize(newSize:Int):Void {
		var newBuffer = new ArrayBuffer(newSize);
		var prevBuffer = arrayBuffer;
		var prevBufferView = uint8Array;
		var prevOffset = _offset;
		var prevOffsetLength = _offsetLength;

		set_arrayBuffer(newBuffer);

		if (prevBuffer != null) {
			if (newSize < prevBuffer.byteLength) {
				uint8Array.set(prevBufferView.subarray(0, newSize));
			} else {
				uint8Array.set(prevBufferView);
			}
		}
		_allocedLength = newSize;
		_offsetLength = prevOffsetLength;
		_offset = prevOffset;
	}

	public function trim():Void {
		if (arrayBuffer == null) {
			return;
		}

		var newBuffer = new ArrayBuffer(offsetLength);
		var prevBuffer = arrayBuffer;
		var prevBufferView = uint8Array;
		var prevOffset = offset;
		var prevOffsetLength = offsetLength;

		set_arrayBuffer(newBuffer);

		uint8Array.set(prevBufferView.subarray(prevOffset, prevOffset + prevOffsetLength));
	}
}

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

import haxe.io.Bytes;
import flash.utils.Endian;
import flash.utils.ByteArray;
import types.DataType;

class Data
{
    inline static public var SIZE_OF_INT8: Int = 1;
    inline static public var SIZE_OF_UINT8: Int = 1;
    inline static public var SIZE_OF_INT16: Int = 2;
    inline static public var SIZE_OF_UINT16: Int = 2;
    inline static public var SIZE_OF_INT32: Int = 4;
    inline static public var SIZE_OF_UINT32: Int = 4;
    inline static public var SIZE_OF_FLOAT32: Int = 4;
    inline static public var SIZE_OF_FLOAT64: Int = 8;

    public var offsetLength: Int;
    public var allocedLength(default, null): Int;
    @:isVar public var byteArray(get, set): ByteArray;
    public var offset: Int;
    public var internalOffset(get, null): Int;
    inline private function get_internalOffset(): Int{return 0;}

    private var _internalByteArrayOffset : Int = 0;

    public function resetOffset() : Void
    {
        offset = 0;
        offsetLength = allocedLength;
    }

    public function new(sizeInBytes : Int) : Void
    {
        if(sizeInBytes != 0)
        {
            var newByteArray : ByteArray = new ByteArray();
            newByteArray.endian = Endian.LITTLE_ENDIAN;
            newByteArray.length = sizeInBytes;
            newByteArray.position = 0;
            set_byteArray(newByteArray);
        }
    }

    private function get_byteArray() : ByteArray
    {
        return byteArray;
    }

    private function set_byteArray(value : ByteArray) : ByteArray
    {
        byteArray = value;
        allocedLength = byteArray.length;
        _internalByteArrayOffset = byteArray.position;
        resetOffset();
        return byteArray;
    }

    public function writeData(data : Data) : Void
    {
        setByteArrayPositionLazily();
        byteArray.writeBytes(data.byteArray, data.offset, data.offsetLength);
        _internalByteArrayOffset += data.offsetLength;
    }

    // Int write and read functions

    public function writeInt(value : Int, targetDataType : DataType) : Void
    {
        switch(targetDataType)
        {
            case DataType.DataTypeInt8: writeInt8(value);
            case DataType.DataTypeUInt8: writeUInt8(value);
            case DataType.DataTypeInt16: writeInt16(value);
            case DataType.DataTypeUInt16: writeUInt16(value);
            case DataType.DataTypeInt32: writeInt32(value);
            case DataType.DataTypeUInt32: writeUInt32(value);
            case DataType.DataTypeFloat32: writeFloat32(value);
            case DataType.DataTypeFloat64: writeFloat64(value);
        }
    }

    public function writeIntArray(array : Array<Int>, dataType : DataType) : Void
    {
        var dataSize = types.DataTypeUtils.dataTypeByteSize(dataType);
        var prevOffset = offset;

        for(i in 0...array.length)
        {
            offset = prevOffset + (i * dataSize);
            writeInt(array[i], dataType);
        }

        offset = prevOffset;
    }

    public function writeInt8(value : Int) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_INT8;
        byteArray.writeByte(value);
    }

    public function writeUInt8(value : Int) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_UINT8;
        byteArray.writeByte(value);
    }

    public function writeInt16(value : Int) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_INT16;
        byteArray.writeShort(value);
    }

    public function writeUInt16(value : Int) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_UINT16;
        byteArray.writeShort(value);
    }

    public function writeInt32(value : Int) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_INT32;
        byteArray.writeInt(value);
    }

    public function writeUInt32(value : Int) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_UINT32;
        byteArray.writeUnsignedInt(value);
    }

    public function readInt(targetDataType : DataType) : Int
    {
        switch(targetDataType)
        {
            case DataType.DataTypeInt8: return readInt8();
            case DataType.DataTypeUInt8: return readUInt8();
            case DataType.DataTypeInt16: return readInt16();
            case DataType.DataTypeUInt16: return readUInt16();
            case DataType.DataTypeInt32: return readInt32();
            case DataType.DataTypeUInt32: return readUInt32();
            case DataType.DataTypeFloat32: return Std.int(readFloat32());
            case DataType.DataTypeFloat64: return Std.int(readFloat64());
        }
    }

    public function readIntArray(count : Int, targetDataType : DataType) : Array<Int>
    {
        var dataSize = types.DataTypeUtils.dataTypeByteSize(targetDataType);
        var prevOffset = offset;
        var returnArray = new Array<Int>();

        for(i in 0...count)
        {
            offset = prevOffset + (i * dataSize);
            returnArray.push(readInt(targetDataType));
        }

        offset = prevOffset;

        return returnArray;
    }

    public function readInt8() : Int
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_INT8;
        return byteArray.readByte();
    }

    public function readUInt8() : Int
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_UINT8;
        return byteArray.readUnsignedByte();
    }

    public function readInt16() : Int
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_INT16;
        return byteArray.readShort();
    }

    public function readUInt16() : Int
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_UINT16;
        return byteArray.readUnsignedShort();
    }

    public function readInt32() : Int
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_INT32;
        return byteArray.readInt();
    }

    public function readUInt32() : Int
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_UINT32;
        return byteArray.readUnsignedInt();
    }

    // Float write and read functions

    public function writeFloat(value : Float, targetDataType : DataType) : Void
    {
        switch(targetDataType)
        {
            case DataType.DataTypeInt8: writeInt8(Std.int(value));
            case DataType.DataTypeUInt8: writeUInt8(Std.int(value));
            case DataType.DataTypeInt16: writeInt16(Std.int(value));
            case DataType.DataTypeUInt16: writeUInt16(Std.int(value));
            case DataType.DataTypeInt32: writeInt32(Std.int(value));
            case DataType.DataTypeUInt32: writeUInt32(Std.int(value));
            case DataType.DataTypeFloat32: writeFloat32(value);
            case DataType.DataTypeFloat64: writeFloat64(value);
        }
    }

    public function writeFloatArray(array : Array<Float>, dataType : DataType) : Void
    {
        var dataSize = types.DataTypeUtils.dataTypeByteSize(dataType);
        var prevOffset = offset;

        for(i in 0...array.length)
        {
            offset = prevOffset + (i * dataSize);
            writeFloat(array[i], dataType);
        }

        offset = prevOffset;
    }

    public function writeFloat32(value : Float) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_FLOAT32;
        byteArray.writeFloat(value);
    }

    public function writeFloat64(value : Float) : Void
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_FLOAT64;
        byteArray.writeDouble(value);
    }

    public function readFloat(targetDataType : DataType) : Float
    {
        switch(targetDataType)
        {
            case DataType.DataTypeInt8: return readInt8();
            case DataType.DataTypeUInt8: return readUInt8();
            case DataType.DataTypeInt16: return readInt16();
            case DataType.DataTypeUInt16: return readUInt16();
            case DataType.DataTypeInt32: return readInt32();
            case DataType.DataTypeUInt32: return readUInt32();
            case DataType.DataTypeFloat32: return readFloat32();
            case DataType.DataTypeFloat64: return readFloat64();
        }
    }

    public function readFloatArray(count : Int, targetDataType : DataType) : Array<Float>
    {
        var dataSize = types.DataTypeUtils.dataTypeByteSize(targetDataType);
        var prevOffset = offset;
        var returnArray = new Array<Float>();

        for(i in 0...count)
        {
            offset = prevOffset + (i * dataSize);
            returnArray.push(readFloat(targetDataType));
        }

        offset = prevOffset;

        return returnArray;
    }

    public function readFloat32() : Float
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_FLOAT32;
        return byteArray.readFloat();
    }

    public function readFloat64() : Float
    {
        setByteArrayPositionLazily();
        _internalByteArrayOffset += Data.SIZE_OF_FLOAT64;
        return byteArray.readDouble();
    }

    /*public function readUIntArray(count : Int, targetDataType : DataType) : Array<UInt>
    {
        var dataSize = types.DataTypeUtils.dataTypeByteSize(targetDataType);
        var returnArray = new Array<UInt>();
        var prevOffset = offset;

        for(i in 0...count)
        {
            offset = prevOffset + (i * dataSize);
            returnArray.push(readInt(targetDataType));
        }

        offset = prevOffset;

        return returnArray;
    }
*/

    private function setByteArrayPositionLazily() : Void
    {
        if (_internalByteArrayOffset != offset)
        {
            byteArray.position = offset;
            _internalByteArrayOffset = offset;
        }
    }

    private function advanceInternalByteArrayOffset(targetDataType : DataType) : Void
    {
        _internalByteArrayOffset += DataTypeUtils.dataTypeByteSize(targetDataType);
    }

    public function toString(?dataType : DataType = null) : String
    {
        if(dataType == null)
        {
            dataType = DataTypeInt32;
        }

        var dataTypeSize : Int = DataTypeUtils.dataTypeByteSize(dataType);
        var prevPosition : Int = offset;
        var func: types.DataType -> Float;

        if(dataType == DataTypeFloat32 || dataType == DataTypeFloat64){
            func = readFloat;
        }else{
            func = readInt;
        }

        var returnString:String = "";
        var nextPosition : Int;
        offset = 0;

        setByteArrayPositionLazily();

        while (byteArray.bytesAvailable > 0)
        {
            nextPosition = offset + dataTypeSize;
            returnString += func(dataType);

            offset = nextPosition;

            if(byteArray.bytesAvailable > 0)returnString += ",";
        }

        offset = prevPosition;

        return returnString;
    }

    public function resize(newSize : Int) : Void
    {
        var newBuffer:ByteArray = new ByteArray();
        newBuffer.endian = Endian.LITTLE_ENDIAN;
        newBuffer.length = newSize;
        newBuffer.position = 0;

        if(allocedLength == 0 || byteArray == null)
        {
            set_byteArray(newBuffer);
            return;
        }

        if (newSize > allocedLength)
        {
            newBuffer.writeBytes(byteArray, 0, allocedLength);
        }
        else
        {
            newBuffer.writeBytes(byteArray, 0, newSize);
        }

        var prevOffsetLength = offsetLength;
        var prevOffset = offset;
        set_byteArray(newBuffer);

        allocedLength = newSize;
        offsetLength = prevOffsetLength;
        offset = prevOffset;
    }

    public function trim() : Void
    {
        if (byteArray == null)
        {
            return;
        }

        var newBuffer:ByteArray = new ByteArray();
        newBuffer.endian = Endian.LITTLE_ENDIAN;
        newBuffer.length = offsetLength;
        newBuffer.position = 0;

        setByteArrayPositionLazily();
        newBuffer.writeBytes(byteArray, offset, offsetLength);
        newBuffer.position = 0;

        set_byteArray(newBuffer);
    }

    public function getBytes() : Bytes
    {
        return Bytes.ofData(byteArray);
    }
}

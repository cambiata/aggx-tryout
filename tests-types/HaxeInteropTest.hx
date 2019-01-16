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

/*
 * Created by IntelliJ IDEA.
 * User: rcam
 * Date: 10/06/14
 * Time: 12:16
 */

import types.haxeinterop.HaxeInputInteropStream;
import types.DataInputStream;
import haxe.io.BytesInput;
import types.DataOutputStream;
import haxe.io.BytesOutput;
import types.haxeinterop.HaxeOutputInteropStream;
import haxe.io.Bytes;
import types.Data;

import types.haxeinterop.DataBytesTools;
import types.DataStringTools;

import types.DataType;

import TestHelper;

using types.DataStringTools;
using types.haxeinterop.DataBytesTools;

class HaxeInteropTest extends unittest.TestCase
{
    private function assertFloatArray(floatArray: Array<Float>, data: Data, dataType: DataType): Void
    {
        var failed = false;
        var prevOffset = data.offset;
        var currentOffset = prevOffset;
        for (i in 0...floatArray.length)
        {
            data.offset = currentOffset;
            var f = floatArray[i];
            var fInData = data.readFloat(dataType);
            if (!TestHelper.nearlyEqual(f, fInData))
            {
                failed = true;
                break;
            }
            currentOffset += DataTypeUtils.dataTypeByteSize(dataType);
        }
        data.offset = prevOffset;

        if (failed)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + data.toString(dataType));
            assertTrue(false);
        }
        assertTrue(true);
    }

    private function assertIntArray(intArray: Array<Int>, data: Data, dataType: DataType): Void
    {
        var failed = false;
        var prevOffset = data.offset;
        var currentOffset = prevOffset;
        for (i in 0...intArray.length)
        {
            data.offset = currentOffset;
            var int = intArray[i];
            var intInData = data.readInt(dataType);
            if (int != intInData)
            {
                failed = true;
                break;
            }
            currentOffset += DataTypeUtils.dataTypeByteSize(dataType);
        }
        data.offset = prevOffset;

        if (failed)
        {
            trace("Comparison Failed, expected: " + intArray.toString() + " and got: " + data.toString(dataType));
            assertTrue(false);
        }
        assertTrue(true);
    }

    public function testDataBytesTools(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data((array.length) * 4);
        data.writeIntArray(array, DataTypeInt32);

        var bytes = data.getBytes();
        assertEquals(1, bytes.get(0));
        assertEquals(2, bytes.get(4));
        assertEquals(3, bytes.get(8));
        assertEquals(4, bytes.get(12));
        assertEquals(5, bytes.get(16));

        var data2: Data = bytes.getTypesData();
        assertEquals(1, data2.readInt(DataTypeInt32));
        data2.offset += 4;
        assertEquals(2, data2.readInt(DataTypeInt32));
        data2.offset += 4;
        assertEquals(3, data2.readInt(DataTypeInt32));
        data2.offset += 4;
        assertEquals(4, data2.readInt(DataTypeInt32));
        data2.offset += 4;
        assertEquals(5, data2.readInt(DataTypeInt32));

    }

    public function testOutputStream(): Void
    {
        var data = new Data(32);
        var dataOutput = new DataOutputStream(data);
        var outputStream = new HaxeOutputInteropStream(dataOutput);

        var bytesToWrite = Bytes.alloc(1);

        bytesToWrite.set(0, 1);
        outputStream.write(bytesToWrite);

        bytesToWrite.set(0, 2);
        outputStream.writeFullBytes(bytesToWrite, 0, 1);

        outputStream.writeInt8(3);

        outputStream.writeInt16(-4);

        outputStream.writeUInt16(5);

        outputStream.writeInt24(-6);

        outputStream.writeUInt24(7);

        outputStream.writeInt32(8);

        outputStream.writeFloat(9.123);

        /// wrong in flash
        #if (!flash)
        outputStream.writeDouble(10.123);
        #end

        outputStream.writeString("a");

        bytesToWrite.set(0, 11);

        var input = new BytesInput(bytesToWrite);
        outputStream.writeInput(input);

        var dataInput = new DataInputStream(data);

        var dataFromInput = new Data(dataInput.bytesAvailable);
        dataInput.readIntoData(dataFromInput);

        assertEquals(1, dataFromInput.readInt(DataTypeUInt8));
        dataFromInput.offset += 1;

        assertEquals(2, dataFromInput.readInt(DataTypeUInt8));
        dataFromInput.offset += 1;

        assertEquals(3, dataFromInput.readInt(DataTypeUInt8));
        dataFromInput.offset += 1;

        assertEquals(-4, dataFromInput.readInt(DataTypeInt16));
        dataFromInput.offset += 2;

        assertEquals(5, dataFromInput.readInt(DataTypeInt16));
        dataFromInput.offset += 2;

        var b0 = dataFromInput.readInt(DataTypeUInt8);
        dataFromInput.offset += 1;
        var b1 = dataFromInput.readInt(DataTypeUInt8);
        dataFromInput.offset += 1;
        var b2 = dataFromInput.readInt(DataTypeUInt8);
        dataFromInput.offset += 1;

        var int24Value = b0 | (b1 << 8) | (b2 << 16);
        if (int24Value & 0x800000 != 0)
            int24Value -= 0x1000000;
        assertEquals(-6, int24Value);

        b0 = dataFromInput.readInt(DataTypeUInt8);
        dataFromInput.offset += 1;

        b1 = dataFromInput.readInt(DataTypeUInt8);
        dataFromInput.offset += 1;

        b2 = dataFromInput.readInt(DataTypeUInt8);
        dataFromInput.offset += 1;

        int24Value = b0 | (b1 << 8) | (b2 << 16);
        assertEquals(7, int24Value);

        assertEquals(8, dataFromInput.readInt(DataTypeInt32));
        dataFromInput.offset += 4;

        assertTrue(TestHelper.nearlyEqual(9.123, dataFromInput.readFloat(DataTypeFloat32)));
        dataFromInput.offset += 4;

        /// wrong in flash
        #if (!flash)
        assertTrue(TestHelper.nearlyEqual(10.123, dataFromInput.readFloat(DataTypeFloat64)));
        dataFromInput.offset += 8;
        #end

        dataFromInput.offsetLength = 1;
        assertEquals("a", dataFromInput.readString());
        dataFromInput.offset += 1;

        assertEquals(11, dataFromInput.readInt(DataTypeUInt8));
    }

    public function testInputStream(): Void /// readAll, readFullBytes still untested..
    {
        var data = new Data(64);

        data.writeInt(1, DataTypeUInt8);
        data.offset += 1;
        data.writeInt(2, DataTypeUInt8);
        data.offset += 1;
        data.writeInt(3, DataTypeUInt8);
        data.offset += 1;
        data.writeInt(-4, DataTypeInt16);
        data.offset += 2;
        data.writeInt(5, DataTypeInt16);
        data.offset += 2;

        data.writeInt(-6, DataTypeUInt8);
        data.offset += 1;
        data.writeInt(255, DataTypeUInt8);
        data.offset += 1;
        data.writeInt(255, DataTypeUInt8);
        data.offset += 1;

        /// 7 0 0 = 7
        data.writeInt(7, DataTypeUInt8);
        data.offset += 1;
        data.writeInt(0, DataTypeUInt8);
        data.offset += 1;
        data.writeInt(0, DataTypeUInt8);
        data.offset += 1;

        data.writeInt(8, DataTypeInt32);
        data.offset += 4;

        data.writeFloat(9.123, DataTypeFloat32);
        data.offset += 4;

        data.writeFloat(10.123, DataTypeFloat64);
        data.offset += 8;

        data.writeString("a");
        data.offset += 1;

        data.writeInt(11, DataTypeUInt8);
        data.offset += 1;

        data.writeString("abc\n");
        data.offset += 4;

        data.writeString("xyz%");
        data.offset += 4;

        data.writeString("abcxyz\n");

        data.offset = 0;

        var dataInput = new DataInputStream(data);
        var haxeInput = new HaxeInputInteropStream(dataInput);

        assertEquals(1, haxeInput.readInt8());
        assertEquals(2, haxeInput.read(1).get(0));
        assertEquals(3, haxeInput.readInt8());
        assertEquals(-4, haxeInput.readInt16());
        assertEquals(5, haxeInput.readUInt16());

        assertEquals(-6, haxeInput.readInt24());
        assertEquals(7, haxeInput.readUInt24());

        assertEquals(8, haxeInput.readInt32());
        assertTrue(TestHelper.nearlyEqual(9.123, haxeInput.readFloat()));

        assertTrue(TestHelper.nearlyEqual(10.123, haxeInput.readDouble()));

        assertEquals("a", haxeInput.readString(1));
        assertEquals(11, haxeInput.readInt8());

        assertEquals("abc", haxeInput.readLine());
        assertEquals("xyz", haxeInput.readUntil("%".charCodeAt(0)));
    }
}
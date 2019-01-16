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

import types.DataType.DataTypeUtils;
import types.Matrix3;
import types.Data;
import types.DataStringTools;

import types.DataType;

import TestHelper;

using types.DataStringTools;
using types.Matrix3DataTools;

class DataTest extends unittest.TestCase
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

    public function testCreation(): Void
    {
        var data = new Data(4);
        assertTrue(data != null && data.allocedLength == 4);
    }

    public function testSettingAFloat(): Void
    {
        var data = new Data(4);
        data.writeFloat(1.1, DataTypeFloat32);
        assertFloatArray([1.1], data, DataTypeFloat32);
    }

    public function testSettingUnsignedShort(): Void
    {
        var data = new Data(2);
        data.writeInt(1, DataTypeUInt16);
        assertIntArray([1], data, DataTypeUInt16);

    }

    public function testSettingUnsignedByte(): Void
    {
        var data = new Data(1);
        data.writeInt(1, DataTypeUInt8);
        assertIntArray([1], data, DataTypeUInt8);
    }

    public function testSettingDouble(): Void
    {
        var data = new Data(8);
        data.writeFloat(1.01223, DataTypeFloat64);
        assertFloatArray([1.01223], data, DataTypeFloat64);
    }

    public function testSettingIntArray(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data(array.length * 4);
        data.writeIntArray(array, DataTypeInt32);

        assertIntArray([1, 2, 3, 4, 5], data, DataTypeInt32);
    }

    public function testSettingFloatArray(): Void
    {
        var array = [1.1, 2.1, 3.1, 4.1, 5.1];
        var data = new Data(array.length * 4);
        data.writeFloatArray(array, DataTypeFloat32);

        assertFloatArray([1.1, 2.1, 3.1, 4.1, 5.1], data, DataTypeFloat32);
    }

    public function testSettingData(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data(array.length * 4);
        data.writeIntArray(array, DataTypeInt32);

        var array2 = [6, 7];
        var data2 = new Data(array2.length * 4);
        data2.writeIntArray(array2, DataTypeInt32);

        data.writeData(data2);

        assertIntArray([6, 7, 3, 4, 5], data, DataTypeInt32);
    }

    public function testSettingValueWithOffset(): Void
    {
        var data = new Data(2 * 4);
        data.writeInt(1, DataTypeInt32);
        data.offset = 4;
        data.writeInt(2, DataTypeInt32);
        data.offset = 0;

        assertIntArray([1, 2], data, DataTypeInt32);
    }

    public function testSettingDataWithOffset(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data(array.length * 4);
        data.writeIntArray(array, DataTypeInt32);

        var array2 = [6, 7];
        var data2 = new Data(array2.length * 4);
        data2.writeIntArray(array2, DataTypeInt32);

        data.offset = 8;
        data.writeData(data2);
        data.offset = 0;

        assertIntArray([1, 2, 6, 7, 5], data, DataTypeInt32);
    }

    public function testSettingArrayWithOffset(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data(array.length * 4);
        data.writeIntArray(array, DataTypeInt32);

        var array2 = [6, 7];
        data.offset = 8;
        data.writeIntArray(array2, DataTypeInt32);
        data.offset = 0;

        assertIntArray([1, 2, 6, 7, 5], data, DataTypeInt32);
    }

    public function testDataStringTools(): Void
    {
        var str = "Test String With 2 byte UTF8 character <†> and 4 byte UTF8 character <১>";
        assertTrue(str.sizeInBytes() == 76);

        var data = new Data(str.sizeInBytes());
        data.writeString(str);

        var newStr = data.readString();
        assertTrue(str == newStr);
    }

    public function testResize(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data((array.length - 1) * 4);
        data.resize((array.length) * 4);
        data.writeIntArray(array, DataTypeInt32);

        assertIntArray([1, 2, 3, 4, 5], data, DataTypeInt32);

    }

    public function testResizeFrom0(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data(0);
        data.resize((array.length) * 4);
        data.writeIntArray(array, DataTypeInt32);

        assertIntArray([1, 2, 3, 4, 5], data, DataTypeInt32);
    }

    public function testTrimming(): Void
    {
        var array = [1, 2, 3, 4, 5];
        var data = new Data(array.length * DataTypeUtils.dataTypeByteSize(DataTypeInt32));
        data.writeIntArray(array, DataTypeInt32);

        /// should start at 3
        data.offset = 2 * DataTypeUtils.dataTypeByteSize(DataTypeInt32);
        /// should have 2 elements
        data.offsetLength = 2 * DataTypeUtils.dataTypeByteSize(DataTypeInt32);

        data.trim();

        assertEquals(data.offsetLength, data.allocedLength);
        assertEquals(data.offset, 0);
        assertIntArray([3, 4], data, DataTypeInt32);
    }

    public function testWriteMatrix3IntoData(): Void
    {
        var data = new Data(9 * DataTypeUtils.dataTypeByteSize(DataType.DataTypeFloat32));

        var matrix = new Matrix3();
        matrix.setIdentity();
        matrix.scale(2, 2, 2);

        matrix.writeMatrix3IntoData(data);

        assertFloatArray([2, 0, 0, 0, 2, 0, 0, 0, 2], data, DataType.DataTypeFloat32);
    }

    ///missing testing offset with smaller types than int/float, and future big types like double
}
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

import types.Matrix4;
import types.Matrix3;

using types.Matrix3Tools;
using types.Matrix3Matrix4Tools;

class Matrix3Test extends unittest.TestCase
{
    private function assertMatrix3(floatArray: Array<Float>, matrix3: Matrix3): Void
    {
        var failed = false;

        for (i in 0...floatArray.length)
        {
            var f = floatArray[i];
            var row: Int = Math.floor(i / 3);
            var col: Int = i % 3;
            var fInMatrix3 = matrix3.get(row, col);
            if (!TestHelper.nearlyEqual(f, fInMatrix3))
            {
                failed = true;
                break;
            }
        }

        if (failed == true)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + matrix3.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

    private function assertFloat(expectedValue: Float, value: Float): Void
    {
        if (!TestHelper.nearlyEqual(value, expectedValue))
        {
            trace('Comparison Failed, expected: $expectedValue and got $value');
            assertTrue(false);
        }
        assertTrue(true);
    }

    public function testCreation(): Void
    {
        var mat3 = new Matrix3();

        assertMatrix3([1, 0, 0, 0, 1, 0, 0, 0, 1], mat3);
    }

    public function testSetIdentity(): Void
    {
        var mat3 = new Matrix3();
        mat3.setIdentity();

        assertMatrix3([1, 0, 0, 0, 1, 0, 0, 0, 1], mat3);
    }

    public function testSet(): Void
    {
        var aMat3 = getPreDefinedMatrix3();

        assertMatrix3([1, 2, 3, 4, 5, 6, 7, 8, 9], aMat3);

        var bMat3 = new Matrix3();
        bMat3.set(aMat3);

        assertMatrix3([1, 2, 3, 4, 5, 6, 7, 8, 9], bMat3);
    }

    public function testMultiply(): Void
    {
        var multiplier = getPreDefinedMatrix3();

        var mat3 = getPreDefinedMatrix3();
        mat3.multiply(multiplier);

        assertMatrix3([30, 36, 42, 66, 81, 96, 102, 126, 150], mat3);
    }

    public function testPreMultiply(): Void
    {
        var multiplier = getPreDefinedMatrix3();

        var mat3 = getPreDefinedMatrix3();
        mat3.preMultiply(multiplier);

        assertMatrix3([30, 36, 42, 66, 81, 96, 102, 126, 150], mat3);
    }

    public function testScale(): Void
    {
        var mat3 = new Matrix3();
        mat3.scale(2, 2, 2);

        assertMatrix3([2, 0, 0, 0, 2, 0, 0, 0, 2], mat3);
    }

    public function testTranspose(): Void
    {
        var mat3 = getPreDefinedMatrix3();
        mat3.transpose();

        assertMatrix3([1, 4, 7, 2, 5, 8, 3, 6, 9], mat3);
    }

    public function testInverse(): Void
    {
        var mat3 = getPreDefinedMatrix3();
        mat3.inverse();

        assertMatrix3([1, 2, 3, 4, 5, 6, 7, 8, 9], mat3);

        mat3 = getPreDefinedMatrix3();
        mat3.m00 = 9;
        mat3.m22 = 1;
        mat3.inverse();

        assertMatrix3([0.134375, -0.06875, 0.009375, -0.118750, 0.037500, 0.13125, 0.009375, 0.096875, -0.115625], mat3);
    }

    public function testGetDeterminant(): Void
    {
        var mat3 = getPreDefinedMatrix3();

        var determinant = mat3.getDeterminant();
        var expectedDeterminant = 0;

        assertFloat(expectedDeterminant, determinant);

        mat3.m00 = 9;
        mat3.m22 = 1;

        determinant = mat3.getDeterminant();
        expectedDeterminant = -320;

        assertFloat(expectedDeterminant, determinant);
    }

    public function testWriteMatrix4IntoMatrix3(): Void
    {
        var mat4 = new Matrix4();
        mat4.setPerspectiveFov(Math.PI * 0.5, 1280 / 720, 0.1, 100);

        var mat3 = new Matrix3();
        mat3.writeMatrix4IntoMatrix3(mat4);

        var m00 = mat4.get(0, 0);
        var m01 = mat4.get(0, 1);
        var m02 = mat4.get(0, 2);
        var m10 = mat4.get(1, 0);
        var m11 = mat4.get(1, 1);
        var m12 = mat4.get(1, 2);
        var m20 = mat4.get(2, 0);
        var m21 = mat4.get(2, 1);
        var m22 = mat4.get(2, 2);

        assertMatrix3([m00, m01, m02, m10, m11, m12, m20, m21, m22], mat3);
    }

    private function getPreDefinedMatrix3(): Matrix3
    {
        var mat3 = new Matrix3();
        mat3.m00 = 1;
        mat3.m01 = 2;
        mat3.m02 = 3;
        mat3.m10 = 4;
        mat3.m11 = 5;
        mat3.m12 = 6;
        mat3.m20 = 7;
        mat3.m21 = 8;
        mat3.m22 = 9;

        return mat3;
    }
}
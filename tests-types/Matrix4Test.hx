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

import types.Matrix3;
import types.Vector3;
import types.DualQuaternion;
import types.AffineTransformMatrix4Tools;
import types.Matrix4;

import types.AffineTransform;

import types.DataType;

import TestHelper;

using types.AffineTransformMatrix4Tools;
using types.DualQuaternionMatrix4Tools;
using types.Matrix4Tools;

class Matrix4Test extends unittest.TestCase
{
    private function assertMatrix4(floatArray: Array<Float>, matrix: Matrix4): Void
    {
        var failed = false;
        for (i in 0...floatArray.length)
        {
            var f = floatArray[i];
            var row: Int = Math.floor(i / 4);
            var col: Int = i % 4;
            var fInMatrix = matrix.get(row, col);
            if (!TestHelper.nearlyEqual(f, fInMatrix))
            {
                failed = true;
                break;
            }
        }
        if (failed == true)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + matrix.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

    private function assertValue(expectedValue: Float, value: Float): Void
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
        var matrix = new Matrix4();
        assertMatrix4([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], matrix);
    }

    public function testIdentity(): Void
    {
        var matrix = new Matrix4();
        matrix.setIdentity();
        assertMatrix4([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], matrix);
    }

    public function testSetOrtho(): Void
    {
        var matrix = new Matrix4();
        matrix.setOrtho(0, 1024, 1024, 0, -1024, 1024);
        assertMatrix4([0.00195312, 0, 0, -1, 0, -0.00195312, 0, 1, 0, 0, -0.000488281, 0.5, 0, 0, 0, 1], matrix);
    }

    public function testSetPerspectiveFov(): Void
    {
        var matrix = new Matrix4();
        matrix.setPerspectiveFov(Math.PI / 180 * 65, 1280 / 720, 0.1, 100);
        assertMatrix4([0.88294816, 0, 0, 0, 0, 1.56968558, 0, 0, 0, 0, -1.00100100, -0.10010010, 0, 0, -1, 0], matrix);
    }

    public function testSet2D(): Void
    {
        var matrix = new Matrix4();
        matrix.set2D(123.45, 543.21, 2.5, 30.0);
        assertMatrix4([2.16506, 1.25, 0, 123.45, -1.25, 2.16506, 0, 543.21, 0, 0, 1, 0, 0, 0, 0, 1], matrix);
    }

    public function testMultiply(): Void
    {
        var first = new Matrix4();
        first.set2D(123.45, 543.21, 1, 0);

        var second = new Matrix4();
        second.set2D(0, 0, 2.5, 0);

        var third = new Matrix4();
        third.set2D(0, 0, 1, 30.0);

        second.multiply(third);
        assertMatrix4([2.16506, 1.25, 0, 0, -1.25, 2.16506, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], second);

        first.multiply(second);
        assertMatrix4([2.16506, 1.25, 0, 946.29, -1.25, 2.16506, 0, 1021.77, 0, 0, 1, 0, 0, 0, 0, 1], first);
    }

    public function testSet(): Void
    {
        var matrix1 = new Matrix4();
        matrix1.set2D(123.45, 543.21, 2.5, 30.0);

        var matrix2 = new Matrix4();
        matrix2.set(matrix1);
        assertMatrix4([2.16506, 1.25, 0, 123.45, -1.25, 2.16506, 0, 543.21, 0, 0, 1, 0, 0, 0, 0, 1], matrix2);
    }

    public function testSetFromAffineTransform(): Void
    {
        var affineTransform = new AffineTransform();
        affineTransform.setIdentity();
        affineTransform.translate(42, 24);

        var matrix = new Matrix4();
        matrix.setFromAffineTransform(affineTransform);

        assertMatrix4([1, 0, 0, 42, 0, 1, 0, 24, 0, 0, 1, 0, 0, 0, 0, 1], matrix);
    }

    public function testSetFromDualQuaternion(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);

        var dualQuaternion = new DualQuaternion();
        dualQuaternion.setIdentity();
        dualQuaternion.setTranslation(vec3);

        var matrix = new Matrix4();
        matrix.setFromDualQuaternion(dualQuaternion);

        assertMatrix4([1, 0, 0, 42, 0, 1, 0, 24, 0, 0, 1, 18, 0, 0, 0, 1], matrix);
    }

    public function testSetFromDualQuaternionWithScale(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);

        var dualQuaternion = new DualQuaternion();
        dualQuaternion.setIdentity();
        dualQuaternion.setTranslation(vec3);

        var vec3Scale = new Vector3();
        vec3.setXYZ(2, 2, 2);

        var matrix = new Matrix4();
        matrix.setFromDualQuaternionWithScale(dualQuaternion, vec3Scale);

        assertMatrix4([0, 0, 0, 42, 0, 0, 0, 24, 0, 0, 0, 18, 0, 0, 0, 1], matrix);
    }

    public function testSetFromDualQuaternionWithScaleMatrix(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);

        var dualQuaternion = new DualQuaternion();
        dualQuaternion.setIdentity();
        dualQuaternion.setTranslation(vec3);

        var mat3Scale = new Matrix3();
        mat3Scale.scale(2, 2, 2);

        var matrix = new Matrix4();
        matrix.setFromDualQuaternionWithScaleMatrix(dualQuaternion, mat3Scale);

        assertMatrix4([2, 0, 0, 84, 0, 2, 0, 48, 0, 0, 2, 36, 0, 0, 0, 1], matrix);
    }

    public function testTranslate(): Void
    {
        var matrix = new Matrix4();
        matrix.setTranslation(42, 24, 18);
        matrix.translate(42, 24, 18);

        assertMatrix4([1, 0, 0, 84, 0, 1, 0, 48, 0, 0, 1, 36, 0, 0, 0, 1], matrix);
    }

    public function testRotation(): Void
    {
        var matrix = new Matrix4();
        matrix.setTranslation(42, 24, 18);
        matrix.rotate(Math.PI, -Math.PI, Math.PI / 2);

        assertMatrix4([0, 1, 0, 24, -1, 0, 0, -42, 0, 0, 1, 18, 0, 0, 0, 1], matrix);
    }

    public function testRotateWithVector3(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(2, 2, 2);

        var matrix = new Matrix4();
        matrix.setTranslation(42, 24, 18);
        matrix.rotateWithVector3(Math.PI, vec3);

        assertMatrix4([-0.333333, 0.666666, 0.666666, 13.999998, 0.666666, -0.333333, 0.666666, 31.999998, 0.666666, 0.666666, -0.333333, 37.999996, 0, 0, 0, 1], matrix);
    }

    public function testSetLookAt(): Void
    {
        var eye = new Vector3();
        eye.setXYZ(2, 2, 2);

        var center = new Vector3();
        center.setXYZ(0, 0, 0);

        var up = new Vector3();
        up.setXYZ(0, 1, 0);

        var matrix = new Matrix4();
        matrix.setIdentity();
        matrix.setLookAt(eye, center, up);

        assertMatrix4([0.707106, 0, -0.707106, 0, -0.408248, 0.816496, -0.408248, 0, 0.577350, 0.577350, 0.577350, -3.464101, 0, 0, 0, 1], matrix);
    }

    public function testSetTranslation(): Void
    {
        var matrix = new Matrix4();
        matrix.setTranslation(42, 24, 18);

        assertMatrix4([1, 0, 0, 42, 0, 1, 0, 24, 0, 0, 1, 18, 0, 0, 0, 1], matrix);
    }

    public function testSetRotationWithVector3(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(2, 2, 2);

        var matrix = new Matrix4();
        matrix.setTranslation(42, 24, 18);
        matrix.setRotationWithVector3(Math.PI, vec3);

        assertMatrix4([-0.333333, 0.666666, 0.666666, 0, 0.666666, -0.333333, 0.666666, 0, 0.666666, 0.666666, -0.333333, 0, 0, 0, 0, 1], matrix);
    }

    public function testSetRotationX(): Void
    {
        var matrix = new Matrix4();
        matrix.setRotationX(Math.PI / 4);

        assertMatrix4([1, 0, 0, 0, 0, 0.707106, -0.707106, 0, 0, 0.707106, 0.707106, 0, 0, 0, 0, 1], matrix);
    }

    public function testSetRotationY(): Void
    {
        var matrix = new Matrix4();
        matrix.setRotationY(Math.PI / 4);

        assertMatrix4([0.707106, 0, 0.707106, 0, 0, 1, 0, 0, -0.707106, 0, 0.707106, 0, 0, 0, 0, 1], matrix);
    }

    public function testSetRotationZ(): Void
    {
        var matrix = new Matrix4();
        matrix.setRotationZ(Math.PI / 4);

        assertMatrix4([0.707106, -0.707106, 0, 0, 0.707106, 0.707106, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], matrix);
    }

    public function testInterpolate(): Void
    {
        var aMatrix = new Matrix4();
        aMatrix.setOrtho(-1, 1, -1, 1, 0.1, 100);

        var bMatrix = new Matrix4();
        bMatrix.setPerspectiveFov(Math.PI / 180 * 65, 1280 / 720, 0.1, 100);

        var matrix = new Matrix4();
        matrix.interpolate(aMatrix, bMatrix, 0.0);
        assertMatrix4([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -0.010010, -0.001001, 0, 0, 0, 1], matrix);

        matrix.interpolate(aMatrix, bMatrix, 0.5);
        assertMatrix4([0.941474, 0, 0, 0, 0, 1.284842, 0, 0, 0, 0, -0.505505, -0.050550, 0, 0, -0.5, 0.5], matrix);

        matrix.interpolate(aMatrix, bMatrix, 1.0);
        assertMatrix4([0.882948, 0, 0, 0, 0, 1.569685, 0, 0, 0, 0, -1.001001, -0.100100, 0, 0, -1, 0], matrix);
    }

    public function testTranspose(): Void
    {
        var matrix = new Matrix4();
        matrix.setTranslation(42, 24, 18);
        matrix.transpose();

        assertMatrix4([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 42, 24, 18, 1], matrix);
    }

    public function testDeterminant(): Void
    {
        var matrix = new Matrix4();
        matrix.setPerspectiveFov(Math.PI, 1280 / 720, 0.1, 100);

        assertValue(0, matrix.getDeterminant());

        matrix.setTranslation(42, 24, 18);
        matrix.rotate(Math.PI / 5, Math.PI * 2, -Math.PI / 2);

        assertValue(1, matrix.getDeterminant());
    }

    public function testInverse(): Void
    {
        var matrix = new Matrix4();
        matrix.setTranslation(42, 24, 18);
        matrix.inverse();

        assertMatrix4([1, 0, 0, -42, 0, 1, 0, -24, 0, 0, 1, -18, 0, 0, 0, 1], matrix);
    }
}
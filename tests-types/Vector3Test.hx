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
import types.Matrix3Vector3Tools;
import types.Vector3;

using types.Matrix3Vector3Tools;

class Vector3Test extends unittest.TestCase
{
    private function assertVector3(floatArray: Array<Float>, vector3: Vector3): Void
    {
        var failed = false;

        for (i in 0...floatArray.length)
        {
            var f = floatArray[i];
            var fInVector3 = vector3.get(i);

            if (!TestHelper.nearlyEqual(f, fInVector3))
            {
                failed = true;
                break;
            }
        }
        if (failed == true)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + vector3.toString());
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
        var vec3 = new Vector3();

        assertVector3([0, 0, 0], vec3);
    }

    public function testSet(): Void
    {
        var aVec3 = new Vector3();
        aVec3.x = 42;
        aVec3.y = 24;
        aVec3.z = 18;

        assertVector3([42, 24, 18], aVec3);

        var bVec3 = new Vector3();
        bVec3.set(aVec3);

        assertVector3([42, 24, 18], bVec3);
    }

    public function testSetXYZ(): Void
    {
        var vec3 = new Vector3();
        vec3.setRGB(42, 24, 18);

        assertVector3([42, 24, 18], vec3);
    }

    public function testSetRGB(): Void
    {
        var vec3 = new Vector3();
        vec3.setRGB(0.2, 0.3, 0.5);

        assertVector3([0.2, 0.3, 0.5], vec3);
    }

    public function testNegate(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.negate();

        assertVector3([-42, -24, -18], vec3);
    }

    public function testAdd(): Void
    {
        var right = new Vector3();
        right.setXYZ(24, 42, 48);

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.add(right);

        assertVector3([66, 66, 66], vec3);
    }

    public function testSubtract(): Void
    {
        var right = new Vector3();
        right.setXYZ(24, 42, 48);

        var vec3 = new Vector3();
        vec3.setXYZ(66, 66, 66);
        vec3.subtract(right);

        assertVector3([42, 24, 18], vec3);
    }

    public function testMultiply(): Void
    {
        var right = new Vector3();
        right.setXYZ(2, 2, 2);

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.multiply(right);

        assertVector3([84, 48, 36], vec3);
    }

    public function testDivide(): Void
    {
        var right = new Vector3();
        right.setXYZ(2, 2, 2);

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.divide(right);

        assertVector3([21, 12, 9], vec3);
    }

    public function testAddScalar(): Void
    {
        var scalar = 2;

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.addScalar(scalar);

        assertVector3([44, 26, 20], vec3);
    }

    public function testSubtractScalar(): Void
    {
        var scalar = 2;

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.subtractScalar(scalar);

        assertVector3([40, 22, 16], vec3);
    }

    public function testMultiplyScalar(): Void
    {
        var scalar = 2;

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.multiplyScalar(scalar);

        assertVector3([84, 48, 36], vec3);
    }

    public function testDivideScalar(): Void
    {
        var scalar = 2;

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.divideScalar(scalar);

        assertVector3([21, 12, 9], vec3);
    }

    public function testNormalize(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.normalize();

        var scale = 1 / Math.sqrt(42 * 42 + 24 * 24 + 18 * 18);
        var x = 42 * scale;
        var y = 24 * scale;
        var z = 18 * scale;

        assertVector3([x, y, z], vec3);
    }

    public function testLerp(): Void
    {
        var start = new Vector3();
        start.setXYZ(0, 0, 0);

        var end = new Vector3();
        end.setXYZ(42, 24, 18);

        var out = new Vector3();

        out.lerp(start, end, 0.0);
        assertVector3([0, 0, 0], out);

        out.lerp(start, end, 0.5);
        assertVector3([21, 12, 9], out);

        out.lerp(start, end, 1.0);
        assertVector3([42, 24, 18], out);
    }

    public function testCross(): Void
    {
        var right = new Vector3();
        right.setXYZ(2, 2, 2);

        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);
        vec3.cross(right);

        assertVector3([12, -48, 36], vec3);
    }

    public function testLength(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);

        var length = Vector3.length(vec3);
        var expectedLength = Math.sqrt(42 * 42 + 24 * 24 + 18 * 18);

        assertFloat(expectedLength, length);
    }

    public function testLengthSquared(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(42, 24, 18);

        var lengthSquared = Vector3.lengthSquared(vec3);
        var expectedLengthSquared = 42 * 42 + 24 * 24 + 18 * 18;

        assertFloat(expectedLengthSquared, lengthSquared);
    }

    public function testDotProduct(): Void
    {
        var left = new Vector3();
        left.setXYZ(42, 24, 18);

        var right = new Vector3();
        right.setXYZ(24, 42, 48);

        var dotProduct = Vector3.dotProduct(left, right);
        var expectedDotProduct = left.x * right.x + left.y * right.y + left.z * right.z;

        assertFloat(expectedDotProduct, dotProduct);
    }

    public function testDistance(): Void
    {
        var start = new Vector3();
        start.setXYZ(42, 24, 18);

        var end = new  Vector3();
        end.setXYZ(66, 66, 66);

        var distance = Vector3.distance(start, end);

        var worker = new Vector3();
        worker.set(end);
        worker.subtract(start);

        var expectedDistance = Math.sqrt(worker.x * worker.x + worker.y * worker.y + worker.z * worker.z);

        assertFloat(expectedDistance, distance);
    }

    public function testMultiplyVector3WithMatrix3(): Void
    {
        var mat3 = new Matrix3();
        mat3.m00 = mat3.m10 = mat3.m20 = 2;
        mat3.m01 = mat3.m11 = mat3.m21 = 4;
        mat3.m02 = mat3.m12 = mat3.m22 = 6;

        var multiplier = new Vector3();
        multiplier.setXYZ(42, 24, 18);

        var out = new Vector3();

        mat3.multiplyVector3(multiplier, out);

        var x = mat3.m00 * multiplier.x + mat3.m01 * multiplier.y + mat3.m02 * multiplier.z;
        var y = mat3.m10 * multiplier.x + mat3.m11 * multiplier.y + mat3.m12 * multiplier.z;
        var z = mat3.m20 * multiplier.x + mat3.m21 * multiplier.y + mat3.m22 * multiplier.z;

        assertVector3([x, y, z], out);
    }
}
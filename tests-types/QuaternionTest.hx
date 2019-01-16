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

import types.Vector3;
import types.Quaternion;

class QuaternionTest extends unittest.TestCase
{
    private function assertQuaternion(floatArray: Array<Float>, quaternion: Quaternion): Void
    {
        var failed = false;

        for (i in 0 ... floatArray.length)
        {
            var f = floatArray[i];
            var fInQuaternion = quaternion.get(i);

            if (!TestHelper.nearlyEqual(f, fInQuaternion))
            {
                failed = true;
                break;
            }
        }

        if (failed)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + quaternion.toString());
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

    private function assertBool(expectedValue: Bool, value: Bool): Void
    {
        if (expectedValue != value)
        {
            trace('Comparison Failed, expected: $expectedValue and got $value');
            assertTrue(false);
        }
        assertTrue(true);
    }

    public function testCreation(): Void
    {
        var quaternion = new Quaternion();
        assertQuaternion([0, 0, 0, 0], quaternion);
    }

    public function testIdentity(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setIdentity();
        assertQuaternion([0, 0, 0, 1], quaternion);
    }

    public function testSet(): Void
    {
        var aQuaternion = new Quaternion();
        aQuaternion.x = 1;
        aQuaternion.y = 2;
        aQuaternion.z = 3;
        aQuaternion.w = 4;

        assertQuaternion([1, 2, 3, 4], aQuaternion);

        var bQuaternion = new Quaternion();
        bQuaternion.set(aQuaternion);

        assertQuaternion([1, 2, 3, 4], bQuaternion);
    }

    public function testEuler(): Void
    {
        var aQuaternion = new Quaternion();
        aQuaternion.setRotationZ(-Math.PI / 2);

        var vec3 = new Vector3();
        aQuaternion.getEulerRotation(vec3);

        var bQuaternion = new Quaternion();
        bQuaternion.setFromEuler(vec3);

        assertQuaternion([0, 0, -0.707106, 0.707106], bQuaternion);
    }

    public function testSetRotationX(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setRotationX(-Math.PI / 2);

        assertQuaternion([-0.707106, 0, 0, 0.707106], quaternion);
    }

    public function testSetRotationY(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setRotationY(-Math.PI / 2);

        assertQuaternion([0, -0.707106, 0, 0.707106], quaternion);
    }

    public function testSetRotationZ(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setRotationZ(-Math.PI / 2);

        assertQuaternion([0, 0, -0.707106, 0.707106], quaternion);
    }

    public function testGetRotationZ(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setRotationZ(-Math.PI / 2);

        var radians = quaternion.getRotationZ();

        assertFloat(-1.570796, radians);
    }

    public function testSetFromAxisAngle(): Void
    {
        var vec3 = new Vector3();
        vec3.setXYZ(0, 1, 0);

        var quaternion = new Quaternion();
        quaternion.setFromAxisAngle(vec3, -Math.PI / 2);

        assertQuaternion([0, -0.707106, 0, 0.707106], quaternion);
    }

    public function testConjugate(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setXYZW(42, 24, 42, 24);
        quaternion.conjugate();

        assertQuaternion([-42, -24, -42, 24], quaternion);
    }

    public function testNormalize(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setXYZW(42, 24, 42, 24);
        quaternion.normalize();

        assertQuaternion([0.613940, 0.350823, 0.613940, 0.350823], quaternion);
    }

    public function testInverse(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setXYZW(42, 24, 42, 24);
        quaternion.inverse();

        assertQuaternion([-0.613940, -0.350823, -0.613940, 0.350823], quaternion);
    }

    public function testDotProduct(): Void
    {
        var left = new Quaternion();
        left.setXYZW(24, 42, 24, 42);

        var right = new Quaternion();
        right.setXYZW(42, 24, 42, 24);

        var dotProduct = Quaternion.dotProduct(left, right);
        var expectedDotProduct = 4032;

        assertFloat(expectedDotProduct, dotProduct);
    }

    public function testLength(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setXYZW(42, 24, 42, 24);

        var length = Quaternion.length(quaternion);
        var expectedLength = 68.410525;

        assertFloat(expectedLength, length);
    }

    public function testLengthSquared(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setXYZW(42, 24, 42, 24);

        var lengthSquared = Quaternion.lengthSquared(quaternion);
        var expectedLengthSquared = 4680;

        assertFloat(expectedLengthSquared, lengthSquared);
    }

    public function testMultiplyQuaternions(): Void
    {
        var left = new Quaternion();
        left.setXYZW(24, 42, 24, 42);

        var right = new Quaternion();
        right.setXYZW(42, 24, 42, 24);

        var leftRight = new Quaternion();
        leftRight.multiplyQuaternions(left, right);

        assertQuaternion([3528, 2016, 1152, -2016], leftRight);

        var rightLeft = new Quaternion();
        rightLeft.multiplyQuaternions(right, left);

        assertQuaternion([1152, 2016, 3528, -2016], rightLeft);
    }

    public function testAdd(): Void
    {
        var aQuaternion = new Quaternion();
        aQuaternion.setXYZW(42, 24, 42, 24);

        var bQuaternion = new Quaternion();
        bQuaternion.setXYZW(24, 42, 24, 42);

        aQuaternion.add(bQuaternion);

        assertQuaternion([66, 66, 66, 66], aQuaternion);
    }

    public function testMultiplyScalar(): Void
    {
        var quaternion = new Quaternion();
        quaternion.setXYZW(42, 24, 42, 24);
        quaternion.multiplyScalar(2);

        assertQuaternion([84, 48, 84, 48], quaternion);
    }

    public function testEqual(): Void
    {
        var aQuaternion = new Quaternion();
        aQuaternion.setXYZW(42, 24, 42, 24);

        var bQuaternion = new Quaternion();
        bQuaternion.setXYZW(42, 24, 42, 24);

        var cQuaternion = new Quaternion();
        cQuaternion.setXYZW(24, 42, 24, 42);

        var compareResultAB = aQuaternion.isEqual(bQuaternion);
        var expectedCompareResultAB = true;

        assertBool(expectedCompareResultAB, compareResultAB);

        var compareResultAC = aQuaternion.isEqual(cQuaternion);
        var expectedCompareResultAC = false;

        assertBool(expectedCompareResultAC, compareResultAC);
    }

    public function testSlerp(): Void
    {
        var aQuaternion = new Quaternion();
        aQuaternion.setXYZW(42, 24, 42, 24);

        var bQuaternion = new Quaternion();
        bQuaternion.setXYZW(84, 48, 84, 48);

        var outQuaternion = new Quaternion();

        Quaternion.slerp(aQuaternion, bQuaternion, outQuaternion, 0.0);
        assertQuaternion([42, 24, 42, 24], outQuaternion);

        //TODO 0.0 to 0.99 has the same result

        Quaternion.slerp(aQuaternion, bQuaternion, outQuaternion, 1.0);
        assertQuaternion([84, 48, 84, 48], outQuaternion);
    }
}
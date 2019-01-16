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

import de.polygonal.ds.M;
import types.Vector3;
import types.Vector3;
import types.Quaternion;
import types.DualQuaternion;

class DualQuaternionTest extends unittest.TestCase
{
    private function assertDualQuaternion(floatArray: Array<Float>, dualQuaternion: DualQuaternion): Void
    {
        var failed = false;

        for (i in 0 ... floatArray.length)
        {
            var f = floatArray[i];
            var fInDualQuaternion = dualQuaternion.get(i);

            if (!TestHelper.nearlyEqual(f, fInDualQuaternion))
            {
                failed = true;
                break;
            }
        }

        if (failed)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + dualQuaternion.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

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

    private function assertVector3(floatArray: Array<Float>, vec3: Vector3): Void
    {
        var failed = false;

        for (i in 0 ... floatArray.length)
        {
            var f = floatArray[i];
            var fInVec3 = vec3.get(i);

            if (!TestHelper.nearlyEqual(f, fInVec3))
            {
                failed = true;
                break;
            }
        }

        if (failed)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + vec3.toString());
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
        var dq = new DualQuaternion();
        assertDualQuaternion([0, 0, 0, 1, 0, 0, 0, 0], dq);
    }

    public function testIdentity(): Void
    {
        var dq = new DualQuaternion();
        dq.setIdentity();

        assertDualQuaternion([0, 0, 0, 1, 0, 0, 0, 0], dq);
    }

    public function testSet(): Void
    {
        var aDQ = new DualQuaternion();
        aDQ.real.x = 1;
        aDQ.real.y = 2;
        aDQ.real.z = 3;
        aDQ.real.w = 4;
        aDQ.dual.x = 5;
        aDQ.dual.y = 6;
        aDQ.dual.z = 7;
        aDQ.dual.w = 8;

        assertDualQuaternion([1, 2, 3, 4, 5, 6, 7, 8], aDQ);

        var bDQ = new DualQuaternion();
        bDQ.set(aDQ);

        assertDualQuaternion([0.182574, 0.365148, 0.547722, 0.730296, 5, 6, 7, 8], bDQ);
    }

    public function testSetFromQuaternions(): Void
    {
        var real = new Quaternion();
        real.setIdentity();

        var dual = new Quaternion();
        dual.setXYZW(0, 0, 0, 0);

        var dq = new DualQuaternion();
        dq.setFromQuaternions(real, dual);

        assertDualQuaternion([0, 0, 0, 1, 0, 0, 0, 0], dq);
    }

    public function testSetPositionAndRotation(): Void
    {
        var position = new Vector3();
        position.setXYZ(42, 24, 18);

        var vec3Rotation = new Vector3();
        vec3Rotation.setXYZ(1, 2, 3);

        var rotation = new Quaternion();
        rotation.setFromEuler(vec3Rotation);

        var dq = new DualQuaternion();
        dq.setPositionAndRotation(position, rotation);

        assertDualQuaternion([0.754933, -0.206149, 0.501509, -0.368871, 0.127153, -8.163743, -16.708181, -17.893400], dq);
    }

    public function testSetPosition(): Void
    {
        var position = new Vector3();
        position.setXYZ(42, 24, 18);

        var dq = new DualQuaternion();
        dq.setPosition(position);

        assertDualQuaternion([0, 0, 0, 1, 21, 12, 9, 0], dq);
    }

    public function testSetRotation(): Void
    {
        var vec3Rotation = new Vector3();
        vec3Rotation.setXYZ(1, 2, 3);

        var rotation = new Quaternion();
        rotation.setFromEuler(vec3Rotation);

        var dq = new DualQuaternion();
        dq.setRotation(rotation);

        assertDualQuaternion([0.754933, -0.206149, 0.501509, -0.368871, 0, 0, 0, 0], dq);
    }

    public function testSetRotationX(): Void
    {
        var dq = new DualQuaternion();
        dq.setRotationX(-Math.PI / 2);

        assertDualQuaternion([-0.707106, 0, 0, 0.707106, 0, 0, 0, 0], dq);
    }

    public function testSetRotationY(): Void
    {
        var dq = new DualQuaternion();
        dq.setRotationY(-Math.PI / 2);

        assertDualQuaternion([0, -0.707106, 0, 0.707106, 0, 0, 0, 0], dq);
    }

    public function testSetRotationZ(): Void
    {
        var dq = new DualQuaternion();
        dq.setRotationZ(-Math.PI / 2);

        assertDualQuaternion([0, 0, -0.707106, 0.707106, 0, 0, 0, 0], dq);
    }

    public function testGetRotation(): Void
    {
        var vec3Rotation = new Vector3();
        vec3Rotation.setXYZ(1, 2, 3);

        var rotationIn = new Quaternion();
        rotationIn.setFromEuler(vec3Rotation);

        var dq = new DualQuaternion();
        dq.setRotation(rotationIn);

        var rotationOut = dq.getRotation();

        assertQuaternion([0.754933, -0.206149, 0.501509, -0.368871], rotationOut);
    }

    public function testGetEulerRotation(): Void
    {
        var rotationIn = new Vector3();
        rotationIn.setXYZ(1, 2, 3);

        var quaternion = new Quaternion();
        quaternion.setFromEuler(rotationIn);

        var dq = new DualQuaternion();
        dq.setRotation(quaternion);

        var rotationOut = new Vector3();
        dq.getEulerRotation(rotationOut);

        assertVector3([-2.642824, -0.973059, -0.749458], rotationOut);
    }

    public function testSetTranslation(): Void
    {
        var translationIn = new Vector3();
        translationIn.setXYZ(42, 24, 18);

        var dq = new DualQuaternion();
        dq.setIdentity();
        dq.setTranslation(translationIn);

        assertDualQuaternion([0, 0, 0, 1, 21, 12, 9, 0], dq);
    }

    public function testGetTranslation(): Void
    {
        var translationIn = new Vector3();
        translationIn.setXYZ(42, 24, 18);

        var translationOut = new Vector3();

        var dq = new DualQuaternion();
        dq.setIdentity();
        dq.setTranslation(translationIn);
        dq.getTranslation(translationOut);

        assertVector3([42, 24, 18], translationOut);
    }

    public function testMultiplyScalar(): Void
    {
        var translation = new Vector3();
        translation.setXYZ(42, 24, 18);

        var dq = new DualQuaternion();
        dq.setTranslation(translation);
        dq.multiplyScalar(2);

        assertDualQuaternion([0, 0, 0, 1, 42, 24, 18, 0], dq);
    }

    public function testMultiply(): Void
    {
        var translation = new Vector3();
        translation.setXYZ(42, 24, 18);

        var multiplier = new DualQuaternion();
        multiplier.setTranslation(translation);

        var dq = new DualQuaternion();
        dq.setRotationX(-Math.PI / 2);
        dq.multiply(multiplier);

        assertDualQuaternion([-0.707106, 0, 0, 0.707106, 14.849242, 14.849242, -2.121320, 14.849242], dq);
    }

    public function testMultiplyDualQuaternions(): Void
    {
        var aMultiplier = new DualQuaternion();
        aMultiplier.setRotationX(-Math.PI / 2);

        var translation = new Vector3();
        translation.setXYZ(42, 24, 18);

        var bMultiplier = new DualQuaternion();
        bMultiplier.setTranslation(translation);

        var dq = new DualQuaternion();
        dq.multiplyDualQuaternions(aMultiplier, bMultiplier);

        assertDualQuaternion([-0.707106, 0, 0, 0.707106, 14.849242, 14.849242, -2.121320, 14.849242], dq);
    }

    public function testAdd(): Void
    {
        var translation = new Vector3();
        translation.setXYZ(42, 24, 18);

        var addend = new DualQuaternion();
        addend.setTranslation(translation);

        var dq = new DualQuaternion();
        dq.setRotationX(-Math.PI);
        dq.add(addend);

        assertDualQuaternion([-0.707106, 0, 0, 0.707106, 21, 12, 9, 0], dq);
    }

    public function testAddDualQuaternion(): Void
    {
        var translation = new Vector3();
        translation.setXYZ(42, 24, 18);

        var aAddend = new DualQuaternion();
        aAddend.setTranslation(translation);

        var bAddend = new DualQuaternion();
        bAddend.setRotationX(-Math.PI);

        var dq = new DualQuaternion();
        dq.addDualQuaternion(aAddend, bAddend);

        assertDualQuaternion([-0.707106, 0, 0, 0.707106, 21, 12, 9, 0], dq);
    }

    public function testSetFromAxisAngleAndTranslation(): Void
    {
        var axis = new Vector3();
        axis.setXYZ(0, 1, 0);

        var translation = new Vector3();
        translation.setXYZ(42, 24, 0);

        var dq = new DualQuaternion();
        dq.setFromAxisAngleAndTranslation(axis, -Math.PI / 2, translation);

        assertDualQuaternion([0, -0.707106, 0, 0.707106, 14.849242, 8.485281, -14.849242, 8.485281], dq);
    }

    public function testSetFromEulerAndTranslation(): Void
    {
        var euler = new Vector3();
        euler.setXYZ(Math.PI / 2, -Math.PI / 2, Math.PI / 4);

        var translation = new Vector3();
        translation.setXYZ(42, 24, 18);

        var dq = new DualQuaternion();
        dq.setFromEulerAndTranslation(euler, translation);

        assertDualQuaternion([0.270598, -0.653281, -0.270598, 0.653281, 16.351267, 15.957319, -11.086554, 4.592201], dq);
    }

    public function testNormalize(): Void
    {
        var euler = new Vector3();
        euler.setXYZ(Math.PI / 2, -Math.PI / 2, -Math.PI / 4);

        var translation = new Vector3();
        translation.setXYZ(42, 24, 18);

        var dq = new DualQuaternion();
        dq.setFromEulerAndTranslation(euler, translation);
        dq.normalize();

        assertDualQuaternion([0.653281, -0.270598, -0.653281, 0.270598, 0.278562, 22.845620, -11.086554, -4.592201], dq);
    }

    public function testConjungate(): Void
    {
        var real = new Quaternion();
        real.setXYZW(42, 24, 18, 0);
        var dual = new Quaternion();
        dual.setXYZW(42, 24, 18, 0);

        var dq =new DualQuaternion();
        dq.setFromQuaternions(real, dual);
        dq.conjugate();

        assertDualQuaternion([-0.813733, -0.464990, -0.348742, 0, -42, -24, -18, 0], dq);
    }

    public function testDotProduct(): Void
    {
        var real = new Quaternion();
        real.setXYZW(42, 24, 18, 0);
        var dual = new Quaternion();
        dual.setXYZW(42, 24, 18, 0);

        var dqLeft = new DualQuaternion();
        var dqRight = new DualQuaternion();

        var dotProduct = DualQuaternion.dotProduct(dqLeft, dqRight);
        var expectedDotProduct = 1;

        assertFloat(expectedDotProduct, dotProduct);
    }

    public function testSclerp(): Void
    {
        var real = new Quaternion();
        real.setXYZW(42, 24, 18, 0);
        var dual = new Quaternion();
        dual.setXYZW(42, 24, 18, 0);

        var translation = new Vector3();
        translation.setXYZ(24, 42, 48);

        var aDQ = new DualQuaternion();
        aDQ.setFromQuaternions(real, dual);

        var bDQ = new DualQuaternion();
        bDQ.setTranslation(translation);
        bDQ.add(aDQ);

        var out = new DualQuaternion();

        DualQuaternion.sclerp(aDQ, bDQ, out, 0.0);
        assertDualQuaternion([0.813733, 0.464990, 0.348742, 0, 42, 24, 18, 0], out);

        DualQuaternion.sclerp(aDQ, bDQ, out, 0.5);
        assertDualQuaternion([0.751791, 0.429595, 0.322196, 0.382683, 58.555455, 41.114321, 35.300606, 26.500585], out);

        DualQuaternion.sclerp(aDQ, bDQ, out, 1.0);
        assertDualQuaternion([0.575396, 0.328797, 0.246598, 0.707106, 113.396966, 78.941132, 67.455838, 72.993140], out);
    }
}
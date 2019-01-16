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

import types.AffineTransform;
import types.Matrix4;

import TestHelper;

using types.AffineTransformMatrix4Tools;

class AffineTransformTest extends unittest.TestCase
{
    private function assertAffineTransform(floatArray: Array<Float>, affineTransform: AffineTransform): Void
    {
        var failed = false;

        for (i in 0...floatArray.length)
        {
            var f = floatArray[i];
            var fInAffineTransform = affineTransform.get(i);

            if (!TestHelper.nearlyEqual(f, fInAffineTransform))
            {
                failed = true;
                break;
            }
        }
        if (failed == true)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + affineTransform.toString());
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
        var aTransform = new AffineTransform();
        assertAffineTransform([1, 0, 0, 0, 1, 0], aTransform);
    }

    public function testIdentity(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();
        assertAffineTransform([1, 0, 0, 0, 1, 0], aTransform);
    }

    public function testSet(): Void
    {
        var aTransform = new AffineTransform();

        aTransform.a = 0.0;
        aTransform.b = 0.0;
        aTransform.c = 0.0;
        aTransform.d = 0.0;
        aTransform.tx = 42.0;
        aTransform.ty = 24.0;

        assertAffineTransform([0, 0, 42, 0, 0, 24], aTransform);

        var bTransform = new AffineTransform();

        bTransform.set(aTransform);
        assertAffineTransform([0, 0, 42, 0, 0, 24], bTransform);
    }

    public function testConcat(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();
        aTransform.translate(42, 24);

        var bTransform = new AffineTransform();
        bTransform.setIdentity();
        bTransform.scale(2, 2);

        bTransform.preMultiply(aTransform);
        assertAffineTransform([2, 0, 42, 0, 2, 24], bTransform);
    }

    public function testTranslationScale(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.setTranslationScale(42, 24, 2, 2);
        assertAffineTransform([2, 0, 42, 0, 2, 24], aTransform);
    }

    public function testTranslationRotationScale(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.setTranslationRotationScale(42, 24, -Math.PI, 2, 2);
        assertAffineTransform([-2, 0, 42, 0, -2, 24], aTransform);
    }

    public function testTranslationRotationScaleFlip(): Void
    {
        var aTransform = new AffineTransform();

        aTransform.setIdentity();
        aTransform.setTranslationRotationScaleFlip(42, 24, -Math.PI, 2, 2, true, false);
        assertAffineTransform([2, 0, 42, 0, -2, 24], aTransform);

        aTransform.setIdentity();
        aTransform.setTranslationRotationScaleFlip(42, 24, -Math.PI, 2, 2, false, true);
        assertAffineTransform([-2, 0, 42, 0, 2, 24], aTransform);

        aTransform.setIdentity();
        aTransform.setTranslationRotationScaleFlip(42, 24, -Math.PI, 2, 2, true, true);
        assertAffineTransform([2, 0, 42, 0, 2, 24], aTransform);
    }

    public function testOrtho(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.setOrtho(-1.0, 1.0, 1.0, -1.0);
        assertAffineTransform([1, 0, 0, 0, -1, 0], aTransform);
    }

    public function testTranslate(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.translate(42, 24);
        assertAffineTransform([1, 0, 42, 0, 1, 24], aTransform);
    }

    public function testPreTranslate(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.preTranslate(42.0, 24.0);
        assertAffineTransform([1, 0, 42, 0, 1, 24], aTransform);
    }

    public function testScale(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.scale(2, 2);
        assertAffineTransform([2, 0, 0, 0, 2, 0], aTransform);
    }

    public function testPreScale(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.preScale(2, 2);
        assertAffineTransform([2, 0, 0, 0, 2, 0], aTransform);
    }

    public function testRotation(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.rotate(-Math.PI);
        assertAffineTransform([-1, 0, 0, 0, -1, 0], aTransform);

        aTransform.rotate(-Math.PI / 2);
        assertAffineTransform([0, -1, 0, 1, 0, 0], aTransform);

        aTransform.rotate(-Math.PI / 2);
        assertAffineTransform([1, 0, 0, 0, 1, 0], aTransform);
    }

    public function testPreRotate(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.preRotate(-Math.PI);
        assertAffineTransform([-1, 0, 0, 0, -1, 0], aTransform);

        aTransform.preRotate(-Math.PI / 2);
        assertAffineTransform([0, -1, 0, 1, 0, 0], aTransform);

        aTransform.preRotate(-Math.PI / 2);
        assertAffineTransform([1, 0, 0, 0, 1, 0], aTransform);
    }

    public function testSkew(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.skew(10, 10);
        assertAffineTransform([1, 10, 0, 10, 1, 0], aTransform);
    }

    public function testPreSkew(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        aTransform.preSkew(10, 10);
        assertAffineTransform([1, 10, 0, 10, 1, 0], aTransform);
    }

    public function testDeterminant(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        assertFloat(1, aTransform.determinant());
    }

    public function testInvert(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();
        aTransform.translate(42, 24);

        aTransform.invert();

        assertAffineTransform([1, 0, -42, 0, 1, -24], aTransform);
    }

    public function testMultiply(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        var bTransform = new AffineTransform();
        bTransform.setIdentity();

        aTransform.setTranslationRotationScale(42, 24, -Math.PI, 1, 1);
        bTransform.setTranslationRotationScale(24, 42, Math.PI, 2, 2);

        aTransform.multiply(bTransform);
        assertAffineTransform([2, 0, 18, 0, 2, -18], aTransform);
    }

    public function testPreMultiply(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();

        var bTransform = new AffineTransform();
        bTransform.setIdentity();

        aTransform.setTranslationRotationScale(42, 24, -Math.PI, 1, 1);
        bTransform.setTranslationRotationScale(24, 42, Math.PI, 2, 2);

        aTransform.preMultiply(bTransform);
        assertAffineTransform([2, 0, -60, 0, 2, -6], aTransform);
    }

    public function testSetFromMatrix4(): Void
    {
        var aMatrix = new Matrix4();
        aMatrix.set2D(42, 24, 1, 0);

        var aTransform = new AffineTransform();
        aTransform.setFromMatrix4(aMatrix);

        assertAffineTransform([1, 0, 42, 0, 1, 24], aTransform);
    }
}

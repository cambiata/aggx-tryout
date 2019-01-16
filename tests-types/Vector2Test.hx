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
import types.AffineTransformVector2Tools;
import types.Vector2;

import TestHelper;

using types.AffineTransformVector2Tools;

class Vector2Test extends unittest.TestCase
{
    private function assertVector2(floatArray: Array<Float>, vector2: Vector2): Void
    {
        var failed = false;

        for (i in 0...floatArray.length)
        {
            var f = floatArray[i];
            var fInVector2 = vector2.get(i);

            if (!TestHelper.nearlyEqual(f, fInVector2))
            {
                failed = true;
                break;
            }
        }
        if (failed == true)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + vector2.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

    public function testCreation(): Void
    {
        var vec1 = new Vector2();
        assertVector2([0.0, 0.0], vec1);
    }

    public function testSet()
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        assertVector2([23.0, 42.0], vec1);

        var vec2 = new Vector2();
        vec2.set(vec1);

        assertVector2([23.0, 42.0], vec2);

        vec1.setST(vec2.s, vec2.t);

        assertVector2([23.0, 42.0], vec1);

        vec2.x = 5.0;
        vec2.y = 8.0;

        assertVector2([5.0, 8.0], vec2);
    }

    public function testGet(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        var vec2 = new Vector2();
        vec2.x = vec1.x;
        vec2.y = vec1.y;

        assertVector2([23.0, 42.0], vec2);
    }

    public function testNegation(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        vec1.negate();

        assertVector2([-23.0, -42.0], vec1);
    }

    public function testAddition(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        var vec2 = new Vector2();
        vec2.set(vec1);

        vec1.add(vec2);

        assertVector2([2.0 * 23.0, 2.0 * 42.0], vec1);
    }

    public function testSubtraction(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        var vec2 = new Vector2();
        vec2.set(vec1);

        vec1.subtract(vec2);

        assertVector2([0.0, 0.0, 0.0, 0.0], vec1);
    }

    public function testMultiplication(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        var vec2 = new Vector2();
        vec2.set(vec1);

        vec1.multiply(vec2);

        assertVector2([529.0, 1764.0], vec1);
    }

    public function testDivision(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        var vec2 = new Vector2();
        vec2.setXY(23.0, 2.0);

        vec1.divide(vec2);

        assertVector2([1.0, 21.0], vec1);
    }

    public function testAdditionScalar(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        vec1.addScalar(5.5);

        assertVector2([23.0 + 5.5, 42.0 + 5.5], vec1);
    }

    public function testSubtractionScalar(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        vec1.subtractScalar(5.5);

        assertVector2([23.0 - 5.5, 42.0 - 5.5], vec1);
    }

    public function testMultiplicationScalar(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        vec1.multiplyScalar(5.5);

        assertVector2([23.0 * 5.5, 42.0 * 5.5], vec1);
    }

    public function testDivisionScalar(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        vec1.divideScalar(5.5);

        assertVector2([23.0 / 5.5, 42.0 / 5.5], vec1);
    }

    public function testNormalization(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        vec1.normalize();

        var scale: Float = 1.0 / Math.sqrt(23.0 * 23.0 + 42.0 * 42.0);
        var x: Float = scale * 23.0;
        var y: Float = scale * 42.0;

        assertVector2([x, y], vec1);
    }

    public function testLerp(): Void
    {
        var vec1 = new Vector2();

        var lerpStart = new Vector2();
        var lerpEnd = new Vector2();

        lerpStart.setXY(20.0, 1.0);
        lerpEnd.setXY(60.0, 0.0);

        vec1.lerp(lerpStart, lerpEnd, 0.5);

        assertVector2([40.0, 0.5], vec1);
    }

    public function testLength(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        var length = Vector2.length(vec1);
        var test = Math.sqrt(23.0 * 23.0 + 42.0 * 42.0);

        if (!TestHelper.nearlyEqual(length, test))
        {
            trace("Comparison Failed, expected: " + test + " and got: " + length);
            assertTrue(false);
        }

        assertTrue(true);
    }

    public function testLengthSquared(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(23.0, 42.0);

        var length = Vector2.lengthSquared(vec1);
        var test = 23.0 * 23.0 + 42.0 * 42.0;

        if (!TestHelper.nearlyEqual(length, test))
        {
            trace("Comparison Failed, expected: " + test + " and got: " + length);
            assertTrue(false);
        }

        assertTrue(true);
    }

    public function testDistance(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(5.0, 5.0);

        var vec2 = new Vector2();
        vec2.setXY(3.0, 3.0);

        var distance = Vector2.distance(vec1, vec2);

        vec1.subtract(vec2);
        var test = Vector2.length(vec1);

        if (!TestHelper.nearlyEqual(distance, test))
        {
            trace("Comparison Failed, expected: " + test + " and got: " + distance);
            assertTrue(false);
        }

        assertTrue(true);
    }

    public function testDotProduct(): Void
    {
        var vec1 = new Vector2();
        vec1.setXY(5.0, 5.0);

        var vec2 = new Vector2();
        vec2.setXY(3.0, 3.0);

        var dotProduct = Vector2.dotProduct(vec1, vec2);
        var expectedDotProduct = 30;

        if (!TestHelper.nearlyEqual(expectedDotProduct, dotProduct))
        {
            trace("Comparison Failed, expected: " + expectedDotProduct + " and got: " + dotProduct);
            assertTrue(false);
        }

        assertTrue(true);
    }

    public function testMultiplyVector2(): Void
    {
        var aTransform = new AffineTransform();
        aTransform.setIdentity();
        aTransform.setTranslationRotationScale(42, 24, -Math.PI, 2, 2);

        var vecIn = new Vector2();
        vecIn.setXY(24, 42);

        var vecOut = new Vector2();

        aTransform.multiplyVector2(vecIn, vecOut);
        assertVector2([-6, -60], vecOut);
    }
}
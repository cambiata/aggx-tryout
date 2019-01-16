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

import types.Color4F;

class Color4FTest extends unittest.TestCase
{
    private function assertColor4F(floatArray: Array<Float>, color: Color4F)
    {
        assertEquals(floatArray[0], color.r);
        assertEquals(floatArray[1], color.g);
        assertEquals(floatArray[2], color.b);
        assertEquals(floatArray[3], color.a);
    }

    public function testCreation(): Void
    {
        var color = new Color4F();
        assertColor4F([0.0, 0.0, 0.0, 1.0], color);

        var color2 = new Color4F(0.1, 0.2, 0.3, 0.4);
        assertColor4F([0.1, 0.2, 0.3, 0.4], color2);
    }

    public function testToString(): Void
    {
        var color = new Color4F(0.1, 0.2, 0.3, 0.4);
        assertEquals('$color', '{0.1, 0.2, 0.3, 0.4}');
    }

    public function testSettingComponents(): Void
    {
        var color = new Color4F();

        assertColor4F([0.0, 0.0, 0.0, 1.0], color);

        color.r = 0.3;

        assertColor4F([0.3, 0.0, 0.0, 1.0], color);

        color.g = 0.4;

        assertColor4F([0.3, 0.4, 0.0, 1.0], color);

        color.b = 0.5;

        assertColor4F([0.3, 0.4, 0.5, 1.0], color);

        color.a = 0.8;

        assertColor4F([0.3, 0.4, 0.5, 0.8], color);
    }

    public function testEquals(): Void
    {
        var colorA = new Color4F();
        var colorB = new Color4F();

        var uint8step: Float = 1.0 / 256.0;
        var lessUint8step: Float = 1.0 / 257.0;

        assertTrue(colorA.isEqual(colorB));

        colorA.r = 0.5;
        colorB.r = 0.5;

        assertTrue(colorA.isEqual(colorB));

        colorA.r = 0.0;
        colorB.r = 0.0 + uint8step;
        assertFalse(colorA.isEqual(colorB));


        colorA.r = 0.5 - uint8step * 0.5;
        colorB.r = 0.5 + uint8step * 0.5;
        assertFalse(colorA.isEqual(colorB));

        colorA.r = 1.0;
        colorB.r = 1.0 - uint8step;

        assertFalse(colorA.isEqual(colorB));

        colorA.r = 0.0;
        colorB.r = 0.0 + lessUint8step;
        assertTrue(colorA.isEqual(colorB));


        colorA.r = 0.5 - lessUint8step * 0.5;
        colorB.r = 0.5 + lessUint8step * 0.5;
        assertTrue(colorA.isEqual(colorB));

        colorA.r = 1.0;
        colorB.r = 1.0 - lessUint8step;

        assertTrue(colorA.isEqual(colorB));
    }


    public function testNotEquals(): Void
    {
        var colorA = new Color4F();
        var colorB = new Color4F();

        var uint8step: Float = 1.0 / 256.0;
        var lessUint8step: Float = 1.0 / 257.0;

        assertFalse(colorA.isNotEqual(colorB));

        colorA.a = 0.0;
        colorB.a = 0.0 + uint8step;
        assertTrue(colorA.isNotEqual(colorB));

        colorA.a = 0.0;
        colorB.a = 0.0 + lessUint8step;
        assertFalse(colorA.isNotEqual(colorB));

        colorA.a = 1.0;
        colorB.a = 1.0 - lessUint8step;
        assertFalse(colorA.isNotEqual(colorB));

        colorA.a = 1.0;
        colorB.a = 1.0 - lessUint8step;
        assertFalse(colorA.isNotEqual(colorB));
    }
}
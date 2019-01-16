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

import types.Data;
import types.Color4B;

import types.DataType;

import TestHelper;

class Color4BTest extends unittest.TestCase
{
    private function assertColor4B(intArray: Array<Int>, color: Color4B)
    {
        assertEquals(intArray[0], color.r);
        assertEquals(intArray[1], color.g);
        assertEquals(intArray[2], color.b);
        assertEquals(intArray[3], color.a);
    }

    public function testCreation(): Void
    {
        var color = new Color4B();
        assertColor4B([0, 0, 0, 0], color);
    }

    public function testSettingComponents(): Void
    {
        var color = new Color4B();

        assertColor4B([0, 0, 0, 0], color);

        color.r = 123;

        assertColor4B([123, 0, 0, 0], color);

        color.g = 123;

        assertColor4B([123, 123, 0, 0], color);

        color.b = 123;

        assertColor4B([123, 123, 123, 0], color);

        color.a = 123;

        assertColor4B([123, 123, 123, 123], color);
    }

    public function testSettingComponentsBoundValues(): Void
    {
        var color = new Color4B();

        assertColor4B([0, 0, 0, 0], color);

        color.r = 255;
        color.g = 256;
        color.b = 257;

        assertColor4B([255, 0, 1, 0], color);
    }
}
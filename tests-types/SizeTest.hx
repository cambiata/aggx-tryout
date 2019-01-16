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

import types.SizeF;
import types.SizeI;

import TestHelper;

class SizeTest extends unittest.TestCase
{
    private function assertSizeF(_width: Float, _height: Float, _size: SizeF): Void
    {
        var failed = false;

        if (!TestHelper.nearlyEqual(_width, _size.width))
        {
            failed = true;
        }

        if (!TestHelper.nearlyEqual(_height, _size.height))
        {
            failed = true;
        }

        if (failed == true)
        {
            trace("Comparison Failed, expected: " + "Width: " + _width + " Height: " + _height + " and got: " + _size.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

    private function assertSizeI(_width: Int, _height: Int, _size: SizeI): Void
    {
        var failed = false;

        if (!TestHelper.nearlyEqual(_width, _size.width))
        {
            failed = true;
        }

        if (!TestHelper.nearlyEqual(_height, _size.height))
        {
            failed = true;
        }

        if (failed == true)
        {
            trace("Comparison Failed, expected: " + "Width: " + _width + " Height: " + _height + " and got: " + _size.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

    public function testCreation(): Void
    {
        var sizef = new SizeF();
        assertSizeF(0.0, 0.0, sizef);

        var sizei = new SizeI();
        assertSizeI(0, 0, sizei);
    }

    public function testAssignment(): Void
    {
        var sizef = new SizeF();
        sizef.width = 4.23;
        sizef.height = 5.67;
        assertSizeF(4.23, 5.67, sizef);

        var sizei = new SizeI();
        sizei.width = 4;
        sizei.height = 5;
        assertSizeI(4, 5, sizei);
    }

    public function testFlip(): Void
    {
        var sizef = new SizeF();
        sizef.width = 4.23;
        sizef.height = 5.67;
        sizef.flip();
        assertSizeF(5.67, 4.23, sizef);

        var sizei = new SizeI();
        sizei.width = 4;
        sizei.height = 5;
        sizei.flip();
        assertSizeI(5, 4, sizei);
    }

}
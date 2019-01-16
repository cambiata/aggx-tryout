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

import types.RectI;

class RectITest extends unittest.TestCase
{
    private function assertRectI(intArray: Array<Int>, rectI: RectI): Void
    {
        if (intArray[0] != rectI.x     || intArray[1] != rectI.y ||
            intArray[2] != rectI.width || intArray[3] != rectI.height)
        {
            trace("Comparison Failed, expected: " + intArray.toString() + " and got: " + rectI.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

    public function testCreation(): Void
    {
        var rectI = new RectI();
        assertRectI([0, 0, 0, 0], rectI);
    }

    public function testSet(): Void
    {
        var rectI = new RectI();
        rectI.x = 42;
        rectI.y = 24;
        rectI.width = 18;
        rectI.height = 81;

        assertRectI([42, 24, 18, 81], rectI);
    }

    public function testSetOther(): Void
    {
        var otherRectI = new RectI();
        otherRectI.x = 42;
        otherRectI.y = 24;
        otherRectI.width = 18;
        otherRectI.height = 81;

        var rectI = new RectI();
        rectI.set(otherRectI);

        assertRectI([42, 24, 18, 81], rectI);
    }

}
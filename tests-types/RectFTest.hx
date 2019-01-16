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

import types.RectF;

class RectFTest extends unittest.TestCase
{
    private function assertRectF(floatArray: Array<Float>, rectF: RectF): Void
    {
        var failed = false;

        for (i in 0 ... floatArray.length)
        {
            var f = floatArray[i];
            var fInDualQuaternion = rectF.get(i);

            if (!TestHelper.nearlyEqual(f, fInDualQuaternion))
            {
                failed = true;
                break;
            }
        }

        if (failed)
        {
            trace("Comparison Failed, expected: " + floatArray.toString() + " and got: " + rectF.toString());
            assertTrue(false);
        }
        assertTrue(true);
    }

    public function testCreation(): Void
    {
        var rectF = new RectF();

        assertRectF([0.0, 0.0, 0.0, 0.0], rectF);
    }

    public function testSet(): Void
    {
        var rectF = new RectF();
        rectF.x = 42.8;
        rectF.y = 24.2;
        rectF.width = 18.1;
        rectF.height = 81.9;

        assertRectF([42.8, 24.2, 18.1, 81.9], rectF);
    }
}
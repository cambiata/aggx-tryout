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

package types;

class Matrix3
{
    /* Column major [m00, m01, m02, m10, m11, m12, m20, m21, m22]
    [m00 m10 m20]
    [m01 m11 m21]
    [m02 m12 m22]
    */

    public var m00: Float = 1.0;
    public var m01: Float = 0.0;
    public var m02: Float = 0.0;

    public var m10: Float = 0.0;
    public var m11: Float = 1.0;
    public var m12: Float = 0.0;

    public var m20: Float = 0.0;
    public var m21: Float = 0.0;
    public var m22: Float = 1.0;

    public function new()
    {
    }

    public function setIdentity(): Void
    {
        m00 = 1.0;
        m01 = 0.0;
        m02 = 0.0;

        m10 = 0.0;
        m11 = 1.0;
        m12 = 0.0;

        m20 = 0.0;
        m21 = 0.0;
        m22 = 1.0;
    }

    public function set(other: Matrix3): Void
    {
        m00 = other.m00;
        m01 = other.m01;
        m02 = other.m02;

        m10 = other.m10;
        m11 = other.m11;
        m12 = other.m12;

        m20 = other.m20;
        m21 = other.m21;
        m22 = other.m22;
    }

    public function multiply(other: Matrix3): Void
    {
        var tmp00 = m00 * other.m00 + m01 * other.m10 + m02 * other.m20;
        var tmp01 = m00 * other.m01 + m01 * other.m11 + m02 * other.m21;
        var tmp02 = m00 * other.m02 + m01 * other.m12 + m02 * other.m22;

        var tmp10 = m10 * other.m00 + m11 * other.m10 + m12 * other.m20;
        var tmp11 = m10 * other.m01 + m11 * other.m11 + m12 * other.m21;
        var tmp12 = m10 * other.m02 + m11 * other.m12 + m12 * other.m22;

        var tmp20 = m20 * other.m00 + m21 * other.m10 + m22 * other.m20;
        var tmp21 = m20 * other.m01 + m21 * other.m11 + m22 * other.m21;
        var tmp22 = m20 * other.m02 + m21 * other.m12 + m22 * other.m22;

        m00 = tmp00;
        m01 = tmp01;
        m02 = tmp02;

        m10 = tmp10;
        m11 = tmp11;
        m12 = tmp12;

        m20 = tmp20;
        m21 = tmp21;
        m22 = tmp22;
    }

    public function preMultiply(other: Matrix3): Void
    {
        var tmp00 = other.m00 * m00 + other.m01 * m10 + other.m02 * m20;
        var tmp01 = other.m00 * m01 + other.m01 * m11 + other.m02 * m21;
        var tmp02 = other.m00 * m02 + other.m01 * m12 + other.m02 * m22;

        var tmp10 = other.m10 * m00 + other.m11 * m10 + other.m12 * m20;
        var tmp11 = other.m10 * m01 + other.m11 * m11 + other.m12 * m21;
        var tmp12 = other.m10 * m02 + other.m11 * m12 + other.m12 * m22;

        var tmp20 = other.m20 * m00 + other.m21 * m10 + other.m22 * m20;
        var tmp21 = other.m20 * m01 + other.m21 * m11 + other.m22 * m21;
        var tmp22 = other.m20 * m02 + other.m21 * m12 + other.m22 * m22;

        m00 = tmp00;
        m01 = tmp01;
        m02 = tmp02;

        m10 = tmp10;
        m11 = tmp11;
        m12 = tmp12;

        m20 = tmp20;
        m21 = tmp21;
        m22 = tmp22;
    }

    public function scale(sx: Float, sy: Float, sz: Float): Void
    {
        m00 *= sx;
        m01 *= sx;
        m02 *= sx;

        m10 *= sy;
        m11 *= sy;
        m12 *= sy;

        m20 *= sz;
        m21 *= sz;
        m22 *= sz;
    }

    public function get(row: Int, col: Int): Float
    {
        var index = row * 3 + col;

        switch (index) {
            case 0: return m00;
            case 1: return m01;
            case 2: return m02;
            case 3: return m10;
            case 4: return m11;
            case 5: return m12;
            case 6: return m20;
            case 7: return m21;
            case 8: return m22;

            default: return 0.0;
        }
    }

    public function toString(): String
    {
        return '[$m00, $m01, $m02, $m10, $m11, $m12, $m20, $m21, $m22]';
    }
}

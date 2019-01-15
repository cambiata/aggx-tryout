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

using types.Matrix3Tools;

class Matrix3Tools
{
    static public function transpose(matrix: Matrix3): Void
    {
        var m00: Float = matrix.m00;
        var m01: Float = matrix.m01;
        var m02: Float = matrix.m02;
        var m10: Float = matrix.m10;
        var m11: Float = matrix.m11;
        var m12: Float = matrix.m12;
        var m20: Float = matrix.m20;
        var m21: Float = matrix.m21;
        var m22: Float = matrix.m22;

        matrix.m01 = m10;
        matrix.m02 = m20;
        matrix.m10 = m01;
        matrix.m12 = m21;
        matrix.m20 = m02;
        matrix.m21 = m12;
    }

    static public function inverse(matrix: Matrix3): Void
    {
        var determinant: Float = matrix.getDeterminant();

        if (determinant == 0)
        {
            return;
        }

        var det: Float = 1 / determinant;

        var m00: Float = det * (matrix.m11 * matrix.m22 - matrix.m12 * matrix.m21);
        var m01: Float = det * (matrix.m02 * matrix.m21 - matrix.m01 * matrix.m22);
        var m02: Float = det * (matrix.m01 * matrix.m12 - matrix.m02 * matrix.m11);
        var m10: Float = det * (matrix.m12 * matrix.m20 - matrix.m10 * matrix.m22);
        var m11: Float = det * (matrix.m00 * matrix.m22 - matrix.m02 * matrix.m20);
        var m12: Float = det * (matrix.m02 * matrix.m10 - matrix.m00 * matrix.m12);
        var m20: Float = det * (matrix.m10 * matrix.m21 - matrix.m11 * matrix.m20);
        var m21: Float = det * (matrix.m01 * matrix.m20 - matrix.m00 * matrix.m11);
        var m22: Float = det * (matrix.m00 * matrix.m11 - matrix.m01 * matrix.m10);

        matrix.m00 = m00;
        matrix.m01 = m01;
        matrix.m02 = m02;
        matrix.m10 = m10;
        matrix.m11 = m11;
        matrix.m12 = m12;
        matrix.m20 = m20;
        matrix.m21 = m21;
        matrix.m22 = m22;
    }

    static public function getDeterminant(matrix: Matrix3): Float
    {
        return matrix.m00 * matrix.m11 * matrix.m22 + matrix.m10 * matrix.m21 * matrix.m02 +
        matrix.m20 * matrix.m01 * matrix.m12 - matrix.m00 * matrix.m21 * matrix.m12 -
        matrix.m20 * matrix.m11 * matrix.m02 - matrix.m10 * matrix.m01 * matrix.m22;
    }
}

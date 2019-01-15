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

class Matrix3DataTools
{
    /**
     * Writes the values from the Matrix3 into a given Data object. Size and offset of the Data will be uneffected
     * by this function and have to be set before.
    **/
    static public function writeMatrix3IntoData(matrix: Matrix3, data: Data): Void
    {
        var oldOffset: Int = data.offset;

        data.writeFloat32(matrix.m00);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m01);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m02);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m10);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m11);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m12);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m20);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m21);
        data.offset += Data.SIZE_OF_FLOAT32;
        data.writeFloat32(matrix.m22);

        data.offset = oldOffset;
    }
}
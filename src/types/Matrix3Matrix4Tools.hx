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

import types.Matrix4;

class Matrix3Matrix4Tools
{
    static public function writeMatrix4IntoMatrix3(matrix3: Matrix3, matrix4: Matrix4): Void
    {
        var oldOffset: Int = matrix4.data.offset;

        matrix4.data.offset = 0 * Data.SIZE_OF_FLOAT32;
        matrix3.m00 = matrix4.data.readFloat32();
        matrix4.data.offset = 1 * Data.SIZE_OF_FLOAT32;
        matrix3.m01 = matrix4.data.readFloat32();
        matrix4.data.offset = 2 * Data.SIZE_OF_FLOAT32;
        matrix3.m02 = matrix4.data.readFloat32();

        matrix4.data.offset = 4 * Data.SIZE_OF_FLOAT32;
        matrix3.m10 = matrix4.data.readFloat32();
        matrix4.data.offset = 5 * Data.SIZE_OF_FLOAT32;
        matrix3.m11 = matrix4.data.readFloat32();
        matrix4.data.offset = 6 * Data.SIZE_OF_FLOAT32;
        matrix3.m12 = matrix4.data.readFloat32();

        matrix4.data.offset = 8 * Data.SIZE_OF_FLOAT32;
        matrix3.m20 = matrix4.data.readFloat32();
        matrix4.data.offset = 9 * Data.SIZE_OF_FLOAT32;
        matrix3.m21 = matrix4.data.readFloat32();
        matrix4.data.offset = 10 * Data.SIZE_OF_FLOAT32;
        matrix3.m22 = matrix4.data.readFloat32();

        matrix4.data.offset = oldOffset;
    }
}

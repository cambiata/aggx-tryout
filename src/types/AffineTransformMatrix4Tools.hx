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

import types.Data;
import types.DataType;

class AffineTransformMatrix4Tools
{
    static public function setFromMatrix4(affineT: AffineTransform, matrix4: Matrix4): Void
    {
        matrix4.data.offset = 0 * 4;
        affineT.m00 = matrix4.data.readFloat32();

        matrix4.data.offset = 1 * 4;
        affineT.m01 = matrix4.data.readFloat32();

        matrix4.data.offset = 3 * 4;
        affineT.m02 = matrix4.data.readFloat32();

        matrix4.data.offset = 4 * 4;
        affineT.m10 = matrix4.data.readFloat32();

        matrix4.data.offset = 5 * 4;
        affineT.m11 = matrix4.data.readFloat32();

        matrix4.data.offset = 7 * 4;
        affineT.m12 = matrix4.data.readFloat32();

        matrix4.data.offset = 0;
    }

    static public function setFromAffineTransform(matrix4: Matrix4, affineT: AffineTransform): Void
    {
        matrix4.setIdentity();

        matrix4.data.offset = 0 * 4;
        matrix4.data.writeFloat32(affineT.m00);

        matrix4.data.offset = 1 * 4;
        matrix4.data.writeFloat32(affineT.m01);

        matrix4.data.offset = 3 * 4;
        matrix4.data.writeFloat32(affineT.m02);

        matrix4.data.offset = 4 * 4;
        matrix4.data.writeFloat32(affineT.m10);

        matrix4.data.offset = 5 * 4;
        matrix4.data.writeFloat32(affineT.m11);

        matrix4.data.offset = 7 * 4;
        matrix4.data.writeFloat32(affineT.m12);

        matrix4.data.offset = 0;
    }
}

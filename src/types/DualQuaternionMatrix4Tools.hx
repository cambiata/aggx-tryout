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

import types.Matrix3;
import types.Data;
import types.DataType;

class DualQuaternionMatrix4Tools
{
    static private var translation: Vector3 = new Vector3();

    static public function setFromDualQuaternion(matrix4: Matrix4, dualQuaternion: DualQuaternion): Void
    {
        dualQuaternion.normalize();
        dualQuaternion.getTranslation(translation);

        var x: Float = dualQuaternion.real.x;
        var y: Float = dualQuaternion.real.y;
        var z: Float = dualQuaternion.real.z;
        var w: Float = dualQuaternion.real.w;

        var _2x: Float = x + x;
        var _2y: Float = y + y;
        var _2z: Float = z + z;
        var _2w: Float = w + w;

        var m11: Float = 1.0 - _2y * y - _2z * z;
        var m12: Float = _2x * y + _2w * z;
        var m13: Float = _2x * z - _2w * y;
        var m14: Float = 0.0;

        var m21: Float = _2x * y - _2w * z;
        var m22: Float = 1.0 - _2x * x - _2z * z;
        var m23: Float = _2y * z + _2w * x;
        var m24: Float = 0.0;

        var m31: Float = _2x * z + _2w * y;
        var m32: Float = _2y * z - _2w * x;
        var m33: Float = 1.0 - _2x * x - _2y * y;
        var m34: Float = 0.0;

        var m41: Float = translation.x;
        var m42: Float = translation.y;
        var m43: Float = translation.z;
        var m44: Float = 1.0;

        matrix4.data.offset = 0 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m11);

        matrix4.data.offset = 1 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m21);

        matrix4.data.offset = 2 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m31);

        matrix4.data.offset = 3 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m41);

        matrix4.data.offset = 4 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m12);

        matrix4.data.offset = 5 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m22);

        matrix4.data.offset = 6 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m32);

        matrix4.data.offset = 7 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m42);

        matrix4.data.offset = 8 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m13);

        matrix4.data.offset = 9 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m23);

        matrix4.data.offset = 10 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m33);

        matrix4.data.offset = 11 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m43);

        matrix4.data.offset = 12 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m14);

        matrix4.data.offset = 13 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m24);

        matrix4.data.offset = 14 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m34);

        matrix4.data.offset = 15 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m44);
    }

    static public function setFromDualQuaternionWithScale(matrix4: Matrix4, dualQuaternion: DualQuaternion, scale: Vector3): Void
    {
        dualQuaternion.normalize();
        dualQuaternion.getTranslation(translation);

        var x: Float = dualQuaternion.real.x;
        var y: Float = dualQuaternion.real.y;
        var z: Float = dualQuaternion.real.z;
        var w: Float = dualQuaternion.real.w;

        var xScale: Float = scale.x;
        var yScale: Float = scale.y;
        var zScale: Float = scale.z;

        var _2x: Float = x + x;
        var _2y: Float = y + y;
        var _2z: Float = z + z;
        var _2w: Float = w + w;

        var m11: Float = (1.0 - _2y * y - _2z * z) * xScale;
        var m12: Float = (_2x * y + _2w * z) * xScale;
        var m13: Float = (_2x * z - _2w * y) * xScale;
        var m14: Float = 0.0;

        var m21: Float = (_2x * y - _2w * z) * yScale;
        var m22: Float = (1.0 - _2x * x - _2z * z) * yScale;
        var m23: Float = (_2y * z + _2w * x) * yScale;
        var m24: Float = 0.0;

        var m31: Float = (_2x * z + _2w * y) * zScale;
        var m32: Float = (_2y * z - _2w * x) * zScale;
        var m33: Float = (1.0 - _2x * x - _2y * y) * zScale;
        var m34: Float = 0.0;

        var m41: Float = translation.x;
        var m42: Float = translation.y;
        var m43: Float = translation.z;
        var m44: Float = 1.0;

        matrix4.data.offset = 0 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m11);

        matrix4.data.offset = 1 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m21);

        matrix4.data.offset = 2 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m31);

        matrix4.data.offset = 3 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m41);

        matrix4.data.offset = 4 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m12);

        matrix4.data.offset = 5 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m22);

        matrix4.data.offset = 6 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m32);

        matrix4.data.offset = 7 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m42);

        matrix4.data.offset = 8 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m13);

        matrix4.data.offset = 9 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m23);

        matrix4.data.offset = 10 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m33);

        matrix4.data.offset = 11 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m43);

        matrix4.data.offset = 12 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m14);

        matrix4.data.offset = 13 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m24);

        matrix4.data.offset = 14 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m34);

        matrix4.data.offset = 15 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m44);
    }

    static public function setFromDualQuaternionWithScaleMatrix(matrix4: Matrix4, dualQuaternion: DualQuaternion, scale: Matrix3): Void
    {
        dualQuaternion.normalize();
        dualQuaternion.getTranslation(translation);

        var x: Float = dualQuaternion.real.x;
        var y: Float = dualQuaternion.real.y;
        var z: Float = dualQuaternion.real.z;
        var w: Float = dualQuaternion.real.w;

        var _2x: Float = x + x;
        var _2y: Float = y + y;
        var _2z: Float = z + z;
        var _2w: Float = w + w;

        var m00: Float = (1.0 - _2y * y - _2z * z);
        var m01: Float = (_2x * y + _2w * z);
        var m02: Float = (_2x * z - _2w * y);
        var m03: Float = 0.0;

        var m10: Float = (_2x * y - _2w * z);
        var m11: Float = (1.0 - _2x * x - _2z * z);
        var m12: Float = (_2y * z + _2w * x);
        var m13: Float = 0.0;

        var m20: Float = (_2x * z + _2w * y);
        var m21: Float = (_2y * z - _2w * x);
        var m22: Float = (1.0 - _2x * x - _2y * y);
        var m23: Float = 0.0;

        var m30: Float = translation.x;
        var m31: Float = translation.y;
        var m32: Float = translation.z;
        var m33: Float = 1.0;

        // Multiply scale

        var tmp00 = m00 * scale.m00 + m01 * scale.m10 + m02 * scale.m20;
        var tmp01 = m00 * scale.m01 + m01 * scale.m11 + m02 * scale.m21;
        var tmp02 = m00 * scale.m02 + m01 * scale.m12 + m02 * scale.m22;

        var tmp10 = m10 * scale.m00 + m11 * scale.m10 + m12 * scale.m20;
        var tmp11 = m10 * scale.m01 + m11 * scale.m11 + m12 * scale.m21;
        var tmp12 = m10 * scale.m02 + m11 * scale.m12 + m12 * scale.m22;

        var tmp20 = m20 * scale.m00 + m21 * scale.m10 + m22 * scale.m20;
        var tmp21 = m20 * scale.m01 + m21 * scale.m11 + m22 * scale.m21;
        var tmp22 = m20 * scale.m02 + m21 * scale.m12 + m22 * scale.m22;

        var tmp30 = m30 * scale.m00 + m31 * scale.m10 + m32 * scale.m20;
        var tmp31 = m30 * scale.m01 + m31 * scale.m11 + m32 * scale.m21;
        var tmp32 = m30 * scale.m02 + m31 * scale.m12 + m32 * scale.m22;

        m00 = tmp00;
        m01 = tmp01;
        m02 = tmp02;

        m10 = tmp10;
        m11 = tmp11;
        m12 = tmp12;

        m20 = tmp20;
        m21 = tmp21;
        m22 = tmp22;

        m30 = tmp30;
        m31 = tmp31;
        m32 = tmp32;

        matrix4.data.offset = 0 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m00);

        matrix4.data.offset = 1 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m10);

        matrix4.data.offset = 2 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m20);

        matrix4.data.offset = 3 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m30);

        matrix4.data.offset = 4 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m01);

        matrix4.data.offset = 5 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m11);

        matrix4.data.offset = 6 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m21);

        matrix4.data.offset = 7 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m31);

        matrix4.data.offset = 8 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m02);

        matrix4.data.offset = 9 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m12);

        matrix4.data.offset = 10 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m22);

        matrix4.data.offset = 11 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m32);

        matrix4.data.offset = 12 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m03);

        matrix4.data.offset = 13 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m13);

        matrix4.data.offset = 14 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m23);

        matrix4.data.offset = 15 * Data.SIZE_OF_FLOAT32;
        matrix4.data.writeFloat32(m33);
    }
}

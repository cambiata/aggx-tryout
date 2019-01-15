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

class Matrix4
{
    public var data(default, null): Data;

    static private var identity: Data;

    public function new() : Void{
        data = new Data(4 * 4 * Data.SIZE_OF_FLOAT32);
    }

    public function setIdentity(): Void
    {
        if(identity == null)
        {
            identity = new Data(4 * 4 * Data.SIZE_OF_FLOAT32);
            identity.offset = 0;
            identity.writeFloatArray(
                [
                1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0
                ]
                , DataType.DataTypeFloat32);
        }

        data.offset = 0;
        identity.offset = 0;
        data.writeData(identity);
    }

    /// http://msdn.microsoft.com/de-de/library/windows/desktop/bb205349(v=vs.85).aspx
    public function setOrtho( left : Float, right : Float, bottom : Float, top : Float, zNear : Float, zFar : Float) : Void
    {
        var oldOffset = data.offset;

        var ral:Float = right + left;
        var rsl:Float = right - left;
        var tab:Float = top + bottom;
        var tsb:Float = top - bottom;
        var nsf:Float = zNear - zFar;

        var m00:Float = 2.0 / rsl;
        var m01:Float = 0.0;
        var m02:Float = 0.0;
        var m03:Float = 0.0;

        var m04:Float = 0.0;
        var m05:Float = 2.0 / tsb;
        var m06:Float = 0.0;
        var m07:Float = 0.0;

        var m08:Float = 0.0;
        var m09:Float = 0.0;
        var m10:Float = 1.0 / nsf;
        var m11:Float = 0.0;

        var m12:Float = -ral / rsl;     // Offset x
        var m13:Float = -tab / tsb;     // Offset y
        var m14:Float = zNear / nsf;
        var m15:Float = 1.0;

        var counter:Int = 0;

        // Write Right Handed/Transposed

        data.offset = counter;
        data.writeFloat32(m00);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m04);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m08);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m12);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m01);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m05);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m09);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m13);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m02);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m06);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m10);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m14);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m03);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m07);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m11);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m15);

        data.offset = oldOffset;
    }

    public function setPerspectiveFov(fovy: Float, aspect: Float, zNear: Float, zFar: Float): Void
    {
        var yScale: Float = 1.0 / Math.tan(fovy / 2.0);
        var xScale: Float = yScale / aspect;

        var oldOffset = data.offset;

        var m00: Float = xScale;
        var m01: Float = 0.0;
        var m02: Float = 0.0;
        var m03: Float = 0.0;

        var m04: Float = 0.0;
        var m05: Float = yScale;
        var m06: Float = 0.0;
        var m07: Float = 0.0;

        var m08: Float = 0.0;
        var m09: Float = 0.0;
        var m10: Float = zFar/(zNear-zFar);
        var m11: Float = (zFar*zNear)/(zNear-zFar);

        var m12: Float = 0.0;
        var m13: Float = 0.0;
        var m14: Float = -1.0;
        var m15: Float = 0.0;

        var counter:Int = 0;

        data.offset = counter;
        data.writeFloat32(m00);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m01);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m02);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m03);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m04);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m05);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m06);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m07);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m08);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m09);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m10);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m11);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m12);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m13);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m14);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m15);

        data.offset = oldOffset;
    }

    public function set2D(posX: Float, posY: Float, scale: Float, rotation: Float): Void
    {
        var oldOffset = data.offset;

        var theta = rotation * Math.PI / 180.0;
        var c = Math.cos(theta);
        var s = Math.sin(theta);

        var m00:Float = c * scale;
        var m01:Float = -s * scale;
        var m02:Float = 0.0;
        var m03:Float = 0.0;

        var m04:Float = s * scale;
        var m05:Float = c * scale;
        var m06:Float = 0.0;
        var m07:Float = 0.0;

        var m08:Float = 0.0;
        var m09:Float = 0.0;
        var m10:Float = 1.0;
        var m11:Float = 0.0;

        var m12:Float = posX;
        var m13:Float = posY;
        var m14:Float = 0.0;
        var m15:Float = 1.0;

        var counter:Int = 0;

        // Write Right Handed/Transposed

        data.offset = counter;
        data.writeFloat32(m00);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m04);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m08);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m12);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m01);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m05);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m09);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m13);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m02);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m06);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m10);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m14);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m03);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m07);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m11);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(m15);

        data.offset = oldOffset;
    }

    public function set(other : Matrix4) : Void {
        var prevOffset = data.offset;
        data.offset = 0;
        other.data.offset = 0;
        data.writeData(other.data);
        data.offset = prevOffset;
    }

    public function get(row : Int, col : Int) : Float{
        var oldOffset =  data.offset;
        data.offset = (row * 4 + col) * Data.SIZE_OF_FLOAT32;
        var returnValue = data.readFloat32();
        data.offset = oldOffset;
        return returnValue;
    }

    public function multiply(right : Matrix4) : Void{

        var oldOffset = data.offset;

        var counter:Int = 0;

        // Read Right

        right.data.offset = counter;
        var mR00:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR01:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR02:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR03:Float = right.data.readFloat32();

        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR04:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR05:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR06:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR07:Float = right.data.readFloat32();

        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR08:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR09:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR10:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR11:Float = right.data.readFloat32();

        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR12:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR13:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR14:Float = right.data.readFloat32();
        right.data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mR15:Float = right.data.readFloat32();

        right.data.offset = 0;

        // Read Left
        counter = 0;

        data.offset = counter;
        var mL00:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL01:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL02:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL03:Float = data.readFloat32();

        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL04:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL05:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL06:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL07:Float = data.readFloat32();

        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL08:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL09:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL10:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL11:Float = data.readFloat32();

        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL12:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL13:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL14:Float = data.readFloat32();
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        var mL15:Float = data.readFloat32();


        // Calculate

        var out00:Float = mL00 * mR00 + mL04 * mR01 + mL08 * mR02 + mL12 * mR03;
        var out04:Float = mL00 * mR04 + mL04 * mR05 + mL08 * mR06 + mL12 * mR07;
        var out08:Float = mL00 * mR08 + mL04 * mR09 + mL08 * mR10 + mL12 * mR11;
        var out12:Float = mL00 * mR12 + mL04 * mR13 + mL08 * mR14 + mL12 * mR15;

        var out01:Float = mL01 * mR00 + mL05 * mR01 + mL09 * mR02 + mL13 * mR03;
        var out05:Float = mL01 * mR04 + mL05 * mR05 + mL09 * mR06 + mL13 * mR07;
        var out09:Float = mL01 * mR08 + mL05 * mR09 + mL09 * mR10 + mL13 * mR11;
        var out13:Float = mL01 * mR12 + mL05 * mR13 + mL09 * mR14 + mL13 * mR15;

        var out02:Float = mL02 * mR00 + mL06 * mR01 + mL10 * mR02 + mL14 * mR03;
        var out06:Float = mL02 * mR04 + mL06 * mR05 + mL10 * mR06 + mL14 * mR07;
        var out10:Float = mL02 * mR08 + mL06 * mR09 + mL10 * mR10 + mL14 * mR11;
        var out14:Float = mL02 * mR12 + mL06 * mR13 + mL10 * mR14 + mL14 * mR15;

        var out03:Float = mL03 * mR00 + mL07 * mR01 + mL11 * mR02 + mL15 * mR03;
        var out07:Float = mL03 * mR04 + mL07 * mR05 + mL11 * mR06 + mL15 * mR07;
        var out11:Float = mL03 * mR08 + mL07 * mR09 + mL11 * mR10 + mL15 * mR11;
        var out15:Float = mL03 * mR12 + mL07 * mR13 + mL11 * mR14 + mL15 * mR15;


        // Write local
        counter = 0;

        data.offset = counter;
        data.writeFloat32(out00);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out01);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out02);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out03);

        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out04);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out05);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out06);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out07);

        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out08);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out09);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out10);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out11);

        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out12);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out13);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out14);
        data.offset = Data.SIZE_OF_FLOAT32 * ++counter;
        data.writeFloat32(out15);

        data.offset = oldOffset;
    }

    public function toString() : String
    {
        return data.toString(DataTypeFloat32);
    }
}

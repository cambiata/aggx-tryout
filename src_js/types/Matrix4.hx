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


class Matrix4
{
	public var data(default, null): Data;

	private static var identity: Data;

	public function new(): Void{
		data = new Data(4 * 4 * Data.SIZE_OF_FLOAT32);
	}

	public function setIdentity(): Void
	{
		if(identity == null)
		{
			identity = new Data(4 * 4 * Data.SIZE_OF_FLOAT32);
			identity.writeFloatArray([	1.0, 0.0, 0.0, 0.0,
									    0.0, 1.0, 0.0, 0.0,
								 		0.0, 0.0, 1.0, 0.0,
									    0.0, 0.0, 0.0, 1.0], DataTypeFloat32);
		}
        data.offset = 0;
        identity.offset = 0;
		data.writeData(identity);
	}

    /// http://msdn.microsoft.com/de-de/library/windows/desktop/bb205349(v=vs.85).aspx
    public function setOrtho(left: Float, right: Float, bottom: Float, top: Float, zNear: Float, zFar: Float): Void
    {
        var floatView = data.float32Array;

        var ral: Float = right + left;
        var rsl: Float = right - left;
        var tab: Float = top + bottom;
        var tsb: Float = top - bottom;
        var nsf: Float = zNear - zFar;

        var m00: Float = 2.0 / rsl;
        var m01: Float = 0.0;
        var m02: Float = 0.0;
        var m03: Float = 0.0;

        var m04: Float = 0.0;
        var m05: Float = 2.0 / tsb;
        var m06: Float = 0.0;
        var m07: Float = 0.0;

        var m08: Float = 0.0;
        var m09: Float = 0.0;
        var m10: Float = 1.0 / nsf;
        var m11: Float = 0.0;

        var m12: Float = -ral / rsl;     // Offset x
        var m13: Float = -tab / tsb;     // Offset y
        var m14: Float = zNear / nsf;
        var m15: Float = 1.0;

        // Write Right Handed / Transposed

        floatView[0] = m00;
        floatView[1] = m04;
        floatView[2] = m08;
        floatView[3] = m12;

        floatView[4] = m01;
        floatView[5] = m05;
        floatView[6] = m09;
        floatView[7] = m13;

        floatView[8] = m02;
        floatView[9] = m06;
        floatView[10] = m10;
        floatView[11] = m14;

        floatView[12] = m03;
        floatView[13] = m07;
        floatView[14] = m11;
        floatView[15] = m15;
    }

	public function setPerspectiveFov(fovy: Float, aspect: Float, zNear: Float, zFar: Float): Void
	{
		var floatView = data.float32Array;

		var yScale: Float = 1.0 / Math.tan(fovy / 2.0);
		var xScale: Float = yScale / aspect;

		floatView[0] = xScale;
		floatView[1] = 0.0;
		floatView[2] = 0.0;
		floatView[3] = 0.0;

		floatView[4] = 0.0;
		floatView[5] = yScale;
		floatView[6] = 0.0;
		floatView[7] = 0.0;

		floatView[8] = 0.0;
		floatView[9] = 0.0;
		floatView[10] = zFar/(zNear-zFar);
		floatView[11] = (zFar*zNear)/(zNear-zFar);

		floatView[12] = 0.0;
		floatView[13] = 0.0;
		floatView[14] = -1.0;
		floatView[15] = 0.0;
	}

	public function set2D(posX: Float, posY: Float, scale: Float, rotation: Float): Void
	{
		var floatView = data.float32Array;

		var theta = rotation * Math.PI / 180.0;
      	var c = Math.cos(theta);
      	var s = Math.sin(theta);

        // Write Right Handed / Transposed

    	floatView[0] = c * scale;
        floatView[1] = s * scale;
        floatView[2] = 0.0;
        floatView[3] = posX;

    	floatView[4] = -s * scale;
        floatView[5] = c * scale;
        floatView[6] = 0.0;
        floatView[7] = posY;

    	floatView[8] = 0.0;
        floatView[9] = 0.0;
        floatView[10] = 1.0;
        floatView[11] = 0.0;

    	floatView[12] = 0.0;
    	floatView[13] = 0.0;
    	floatView[14] = 0.0;
    	floatView[15] = 1.0;
	}

	public function set(matrix : Matrix4) : Void
	{
        data.offset = 0;
        matrix.data.offset = 0;
		data.writeData(matrix.data);
	}

	public function get(row : Int, col : Int) : Float
	{
		return data.float32Array[row * 4 + col];
	}

	public function multiply(right : Matrix4) : Void
	{
		var a = data.float32Array;
		var b = right.data.float32Array;
		var out = data.float32Array;
   		var a00 = a[0], a01 = a[1], a02 = a[2], a03 = a[3],
        	a10 = a[4], a11 = a[5], a12 = a[6], a13 = a[7],
       		a20 = a[8], a21 = a[9], a22 = a[10], a23 = a[11],
        	a30 = a[12], a31 = a[13], a32 = a[14], a33 = a[15];

	    // Cache only the current line of the second matrix
	    var b0  = b[0], b1 = b[1], b2 = b[2], b3 = b[3];
	    	out[0] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
	    	out[1] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
	    	out[2] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
	    	out[3] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

	    b0 = b[4]; b1 = b[5]; b2 = b[6]; b3 = b[7];
	    out[4] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
	    out[5] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
	    out[6] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
	    out[7] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

	    b0 = b[8]; b1 = b[9]; b2 = b[10]; b3 = b[11];
	    out[8] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
	    out[9] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
	    out[10] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
	    out[11] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

	    b0 = b[12]; b1 = b[13]; b2 = b[14]; b3 = b[15];
	    out[12] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
	    out[13] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
	    out[14] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
	    out[15] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
	}

	public function toString() : String
	{
		var output = "";
		output += "[";

		var view = data.float32Array;
		output += view[0];

		for(i in 1...16)
		{
			output += ", ";
			output += view[i];
		}

		output += "]";
		return output;
	}


}

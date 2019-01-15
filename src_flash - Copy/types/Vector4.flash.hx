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

class Vector4
{
    public var data(default, null) : Data;
    public var dataOffset(default, null) : Int;

    public function new(_data : Data = null, _dataOffset : Int = 0) : Void
    {
        if(_data == null)
        {
            data = new Data(4 * Data.SIZE_OF_FLOAT32);
        }
        else
        {
            data = _data;
        }

        dataOffset = _dataOffset;
    }

/// Vector Interface

    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var z(get, set) : Float;
    public var w(get, set) : Float;

    public function get_x() : Float
    {
        data.offset = dataOffset + 0;
        return data.readFloat32();
    }

    public function set_x(x : Float) : Float
    {
        data.offset = dataOffset + 0;
        data.writeFloat32(x);
        return x;
    }

    public function get_y() : Float
    {
        data.offset = dataOffset + 4;
        return data.readFloat32();
    }

    public function set_y(y : Float) : Float
    {
        data.offset = dataOffset + 4;
        data.writeFloat32(y);
        return y;
    }

    public function get_z() : Float
    {
        data.offset = dataOffset + 8;
        return data.readFloat32();
    }

    public function set_z(z : Float) : Float
    {
        data.offset = dataOffset + 8;
        data.writeFloat32(z);
        return z;
    }

    public function get_w() : Float
    {
        data.offset = dataOffset + 12;
        return data.readFloat32();
    }

    public function set_w(w : Float) : Float
    {
        data.offset = dataOffset + 12;
        data.writeFloat32(w);
        return w;
    }

/// Color Interface

    public var r(get, set) : Float;
    public var g(get, set) : Float;
    public var b(get, set) : Float;
    public var a(get, set) : Float;

    public function get_r() : Float
    {
        data.offset = dataOffset + 0;
        return data.readFloat32();
    }

    public function set_r(r : Float) : Float
    {
        data.offset = dataOffset + 0;
        data.writeFloat32(r);
        return r;
    }

    public function get_g() : Float
    {
        data.offset = dataOffset + 4;
        return data.readFloat32();
    }

    public function set_g(g : Float) : Float
    {
        data.offset = dataOffset + 4;
        data.writeFloat32(g);
        return g;
    }

    public function get_b() : Float
    {
        data.offset = dataOffset + 8;
        return data.readFloat32();
    }

    public function set_b(b : Float) : Float
    {
        data.offset = dataOffset + 8;
        data.writeFloat32(b);
        return b;
    }

    public function get_a() : Float
    {
        data.offset = dataOffset + 12;
        return data.readFloat32();
    }

    public function set_a(a : Float) : Float
    {
        data.offset = dataOffset + 12;
        data.writeFloat32(a);
        return a;
    }

/// Setters & Getters

    public function setXYZW(_x : Float, _y : Float, _z : Float, _w : Float)
    {
        x = _x;
        y = _y;
        z = _z;
        w = _w;
    }

    public function setRGBA(_r : Float, _g : Float, _b : Float, _a : Float)
    {
        r = _r;
        g = _g;
        b = _b;
        a = _a;
    }

    public function set(other : Vector4) : Void
    {
        data.offset = dataOffset;
        other.data.offset = other.dataOffset;
        other.data.offsetLength = 4 * Data.SIZE_OF_FLOAT32;
        data.writeData(other.data);
    }

    public function get(index : Int) : Float
    {
        data.offset = dataOffset + index * Data.SIZE_OF_FLOAT32;
        return data.readFloat32();
    }

/// Math

    public function negate() : Void
    {
        x = -x;
        y = -y;
        z = -z;
        w = -w;
    }

    public function add(right : Vector4) : Void
    {
        x = x + right.x;
        y = y + right.y;
        z = z + right.z;
        w = w + right.w;
    }

    public function subtract(right : Vector4) : Void
    {
        x = x - right.x;
        y = y - right.y;
        z = z - right.z;
        w = w - right.w;
    }

    public function multiply(right : Vector4) : Void
    {
        x = x * right.x;
        y = y * right.y;
        z = z * right.z;
        w = w * right.w;
    }

    public function divide(right : Vector4) : Void
    {
        x = x / right.x;
        y = y / right.y;
        z = z / right.z;
        w = w / right.w;
    }

    public function addScalar(value : Float) : Void
    {
        x = x + value;
        y = y + value;
        z = z + value;
        w = w + value;
    }

    public function subtractScalar(value : Float) : Void
    {
        x = x - value;
        y = y - value;
        z = z - value;
        w = w - value;
    }

    public function multiplyScalar(value : Float) : Void
    {
        x = x * value;
        y = y * value;
        z = z * value;
        w = w * value;
    }

    public function divideScalar(value : Float) : Void
    {
        x = x / value;
        y = y / value;
        z = z / value;
        w = w / value;
    }

    public function normalize() : Void
    {
        var scale:Float = 1.0 / Vector4.length(this);
        multiplyScalar(scale);
    }

    public function lerp(start : Vector4, end : Vector4, t : Float) : Void
    {
        x = start.x + ((end.x - start.x) * t);
        y = start.y + ((end.y - start.y) * t);
        z = start.z + ((end.z - start.z) * t);
        w = start.w + ((end.w - start.w) * t);
    }

    public static function length(vector : Vector4) : Float
    {
        return Math.sqrt(Vector4.lengthSquared(vector));
    }

    public static function lengthSquared(vector : Vector4) : Float
    {
        return vector.x * vector.x + vector.y * vector.y + vector.z * vector.z + vector.w * vector.w;
    }

    public static function dotProduct(left: Vector4, right: Vector4) : Float
    {
        return left.x * right.x + left.y * right.y + left.z * right.z + left.w * right.w;
    }

    private static var distanceVector4:Vector4;
    public static function distance(start : Vector4, end : Vector4) : Float
    {
        if (distanceVector4 == null)
            distanceVector4 = new Vector4();

        distanceVector4.set(end);
        distanceVector4.subtract(start);

        return Vector4.length(distanceVector4);
    }

    public function toString() : String
    {
        var output = "";
        output += "[";

        data.offset = dataOffset;
        output += data.readFloat32();

        for(i in 1...4)
        {
            output += ", ";
            data.offset += 4;
            output += data.readFloat32();
        }

        output += "]";
        return output;
    }

}

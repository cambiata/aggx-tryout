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

class Vector2
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

/// Color Interface

    public var s(get, set) : Float;
    public var t(get, set) : Float;


    public function get_s() : Float
    {
        data.offset = dataOffset + 0;
        return data.readFloat32();
    }

    public function set_s(s : Float) : Float
    {
        data.offset = dataOffset + 0;
        data.writeFloat32(s);
        return s;
    }

    public function get_t() : Float
    {
        data.offset = dataOffset + 4;
        return data.readFloat32();
    }

    public function set_t(t : Float) : Float
    {
        data.offset = dataOffset + 4;
        data.writeFloat32(t);
        return t;
    }

/// Setters & Getters

    public function setXY(_x : Float, _y)
    {
        x = _x;
        y = _y;
    }

    public function setST(_s : Float, _t : Float)
    {
        s = _s;
        t = _t;
    }

    public function set(other : Vector2) : Void
    {
        data.offset = dataOffset;
        other.data.offset = other.dataOffset;
        other.data.offsetLength = 2 * 4;
        data.writeData(other.data);
    }

    public function get(index : Int) : Float
    {
        data.offset = dataOffset + index * 4;
        return data.readFloat32();
    }

/// Math

    public function negate() : Void
    {
        x = -x;
        y = -y;
    }

    public function add(right : Vector2) : Void
    {
        x = x + right.x;
        y = y + right.y;
    }

    public function subtract(right : Vector2) : Void
    {
        x = x - right.x;
        y = y - right.y;
    }

    public function multiply(right : Vector2) : Void
    {
        x = x * right.x;
        y = y * right.y;
    }

    public function divide(right : Vector2) : Void
    {
        x = x / right.x;
        y = y / right.y;
    }

    public function addScalar(value : Float) : Void
    {
        x = x + value;
        y = y + value;
    }

    public function subtractScalar(value : Float) : Void
    {
        x = x - value;
        y = y - value;
    }

    public function multiplyScalar(value : Float) : Void
    {
        x = x * value;
        y = y * value;
    }

    public function divideScalar(value : Float) : Void
    {
        x = x / value;
        y = y / value;
    }

    public function normalize() : Void
    {
        var scale:Float = 1.0 / Vector2.length(this);
        multiplyScalar(scale);
    }

    public function lerp(start : Vector2, end : Vector2, t : Float) : Void
    {
        x = start.x + ((end.x - start.x) * t);
        y = start.y + ((end.y - start.y) * t);
    }

    public static function length(vector : Vector2) : Float
    {
        return Math.sqrt(Vector2.lengthSquared(vector));
    }

    public static function lengthSquared(vector : Vector2) : Float
    {
        return vector.x * vector.x + vector.y * vector.y;
    }

    public static function dotProduct(left: Vector2, right: Vector2) : Float
    {
        return left.x * right.x + left.y * right.y;
    }

    private static var distanceVector2:Vector2;
    public static function distance(start : Vector2, end : Vector2) : Float
    {
        if (distanceVector2 == null)
            distanceVector2 = new Vector2();

        distanceVector2.set(end);
        distanceVector2.subtract(start);

        return Vector2.length(distanceVector2);
    }

    public function toString() : String
    {
        var output = "";
        output += "[";

        data.offset = dataOffset;
        output += data.readFloat32();

        for(i in 1...2)
        {
            output += ", ";
            data.offset += 4;
            output += data.readFloat32();
        }

        output += "]";
        return output;
    }

}

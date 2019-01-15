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

class Vector3
{
    public var data(default, null): Data;
    public var dataOffset(default, null): Int;

    /// Vector Interface

    public var x(get, set): Float;
    public var y(get, set): Float;
    public var z(get, set): Float;

    /// Color Interface

    public var r(get, set): Float;
    public var g(get, set): Float;
    public var b(get, set): Float;

    public function new(_data: Data = null, _dataOffset: Int = 0): Void
    {
        if (_data == null)
        {
            data = new Data(3 * Data.SIZE_OF_FLOAT32);
        }
        else
        {
            data = _data;
        }

        dataOffset = _dataOffset;
    }

    public function get_x(): Float
    {
        data.offset = dataOffset + 0;
        return data.readFloat32();
    }

    public function set_x(value: Float): Float
    {
        data.offset = dataOffset + 0;
        data.writeFloat32(value);
        return value;
    }

    public function get_y(): Float
    {
        data.offset = dataOffset + 4;
        return data.readFloat32();
    }

    public function set_y(value: Float): Float
    {
        data.offset = dataOffset + 4;
        data.writeFloat32(value);
        return value;
    }

    public function get_z(): Float
    {
        data.offset = dataOffset + 8;
        return data.readFloat32();
    }

    public function set_z(value: Float): Float
    {
        data.offset = dataOffset + 8;
        data.writeFloat32(value);
        return value;
    }

    public function get_r(): Float
    {
        data.offset = dataOffset + 0;
        return data.readFloat32();
    }

    public function set_r(value: Float): Float
    {
        data.offset = dataOffset + 0;
        data.writeFloat32(value);
        return value;
    }

    public function get_g(): Float
    {
        data.offset = dataOffset + 4;
        return data.readFloat32();
    }

    public function set_g(value: Float): Float
    {
        data.offset = dataOffset + 4;
        data.writeFloat32(value);
        return value;
    }

    public function get_b(): Float
    {
        data.offset = dataOffset + 8;
        return data.readFloat32();
    }

    public function set_b(value: Float): Float
    {
        data.offset = dataOffset + 8;
        data.writeFloat32(value);
        return value;
    }

    /// Setters & Getters

    public function setXYZ(x: Float, y: Float, z: Float): Void
    {
        set_x(x);
        set_y(y);
        set_z(z);
    }

    public function setRGB(r: Float, g: Float, b: Float): Void
    {
        set_r(r);
        set_g(g);
        set_b(b);
    }

    public function set(other: Vector3): Void
    {
        data.offset = dataOffset;
        other.data.offset = other.dataOffset;
        other.data.offsetLength = 3 * Data.SIZE_OF_FLOAT32;
        data.writeData(other.data);
    }

    public function get(index: Int): Float
    {
        data.offset = dataOffset + index * Data.SIZE_OF_FLOAT32;
        return data.readFloat32();
    }

    /// Math

    public function negate(): Void
    {
        x = -x;
        y = -y;
        z = -z;
    }

    public function add(right: Vector3): Void
    {
        x = x + right.x;
        y = y + right.y;
        z = z + right.z;
    }

    public function subtract(right: Vector3): Void
    {
        x = x - right.x;
        y = y - right.y;
        z = z - right.z;
    }

    public function multiply(right: Vector3): Void
    {
        x = x * right.x;
        y = y * right.y;
        z = z * right.z;
    }

    public function divide(right: Vector3): Void
    {
        x = x / right.x;
        y = y / right.y;
        z = z / right.z;
    }

    public function addScalar(value: Float): Void
    {
        x = x + value;
        y = y + value;
        z = z + value;
    }

    public function subtractScalar(value: Float): Void
    {
        x = x - value;
        y = y - value;
        z = z - value;
    }

    public function multiplyScalar(value: Float): Void
    {
        x = x * value;
        y = y * value;
        z = z * value;
    }

    public function divideScalar(value: Float): Void
    {
        x = x / value;
        y = y / value;
        z = z / value;
    }

    public function normalize(): Void
    {
        var scale: Float = 1.0 / Vector3.length(this);
        multiplyScalar(scale);
    }

    public function lerp(start: Vector3, end: Vector3, t: Float): Void
    {
        x = start.x + ((end.x - start.x) * t);
        y = start.y + ((end.y - start.y) * t);
        z = start.z + ((end.z - start.z) * t);
    }

    public function cross(right: Vector3): Void
    {
        var newX: Float = y * right.z - z * right.y;
        var newY: Float = z * right.x - x * right.z;
        var newZ: Float = x * right.y - y * right.x;

        x = newX;
        y = newY;
        z = newZ;
    }

    static public function length(vector: Vector3): Float
    {
        return Math.sqrt(Vector3.lengthSquared(vector));
    }

    static public function lengthSquared(vector: Vector3): Float
    {
        return vector.x * vector.x + vector.y * vector.y + vector.z * vector.z;
    }

    static public function dotProduct(vectorLeft: Vector3, vectorRight: Vector3): Float
    {
        return vectorLeft.x * vectorRight.x + vectorLeft.y * vectorRight.y + vectorLeft.z * vectorRight.z;
    }

    static private var distanceVector3: Vector3 = new Vector3();

    static public function distance(start: Vector3, end: Vector3): Float
    {
        distanceVector3.set(end);
        distanceVector3.subtract(start);

        return Vector3.length(distanceVector3);
    }

    public function toString(): String
    {
        var output = "";
        output += "[";

        data.offset = dataOffset;
        output += data.readFloat32();

        for (i in 1...3)
        {
            output += ", ";
            data.offset += 4;
            output += data.readFloat32();
        }

        output += "]";
        return output;
    }

}

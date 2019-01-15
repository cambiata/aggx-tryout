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

class Quaternion
{
    public var x: Float = 0.0;
    public var y: Float = 0.0;
    public var z: Float = 0.0;
    public var w: Float = 0.0;

    public function new()
    {
    }

    public function setIdentity(): Void
    {
        x = 0.0;
        y = 0.0;
        z = 0.0;
        w = 1.0;
    }

    public function setXYZW(x: Float, y: Float, z: Float, w: Float): Void
    {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    public function set(other: Quaternion): Void
    {
        x = other.x;
        y = other.y;
        z = other.z;
        w = other.w;
    }

    public function get(index: Int): Float
    {
        switch (index)
        {
            case 0: return x;
            case 1: return y;
            case 2: return z;
            case 3: return w;

            default: return 0.0;
        }
    }

    // Order is XYZ

    public function setFromEuler(euler: Vector3): Void
    {
        var c1 = Math.cos(euler.x / 2.0);
        var c2 = Math.cos(euler.y / 2.0);
        var c3 = Math.cos(euler.z / 2.0);
        var s1 = Math.sin(euler.x / 2.0);
        var s2 = Math.sin(euler.y / 2.0);
        var s3 = Math.sin(euler.z / 2.0);

        x = s1 * c2 * c3 + c1 * s2 * s3;
        y = c1 * s2 * c3 - s1 * c2 * s3;
        z = c1 * c2 * s3 + s1 * s2 * c3;
        w = c1 * c2 * c3 - s1 * s2 * s3;
    }

    public function getEulerRotation(out: Vector3): Void
    {
        var ex: Float;
        var ey: Float;
        var ez: Float;

        var sqw = w * w;
        var sqx = x * x;
        var sqy = y * y;
        var sqz = z * z;
        var unit = sqx + sqy + sqz + sqw; // if normalized is one, otherwise is correction factor

        var test = x * y + z * w;

        if (test > 0.499 * unit) // singularity at north pole
        {
            ey = 2 * Math.atan2(x, w);
            ez = Math.PI * 0.5;
            ex = 0;
        }
        else if (test < -0.499 * unit) // singularity at south pole
        {
            ey = -2 * Math.atan2(x, w);
            ez = -Math.PI * 0.5;
            ex = 0;
        }
        else
        {
            ey = Math.atan2(2 * y * w - 2 * x * z, sqx - sqy - sqz + sqw);
            ez = Math.asin(2 * test / unit);
            ex = Math.atan2(2 * x * w - 2 * y * z, -sqx + sqy - sqz + sqw);
        }

        out.setXYZ(ex, ey, ez);
    }

    public function setRotationX(radians: Float): Void
    {
        var halfAngle = radians * 0.5;
        x = Math.sin(halfAngle);
        y = 0.0;
        z = 0.0;
        w = Math.cos(halfAngle);
    }

    public function setRotationY(radians: Float): Void
    {
        var halfAngle = radians * 0.5;
        x = 0.0;
        y = Math.sin(halfAngle);
        z = 0.0;
        w = Math.cos(halfAngle);
    }

    public function setRotationZ(radians: Float): Void
    {
        var halfAngle = radians * 0.5;
        x = 0.0;
        y = 0.0;
        z = Math.sin(halfAngle);
        w = Math.cos(halfAngle);
    }

    public function getRotationZ(): Float
    {
        var sqw = w * w;
        var sqx = x * x;
        var sqy = y * y;
        var sqz = z * z;
        var unit = sqx + sqy + sqz + sqw; // if normalized is one, otherwise is correction factor

        var test = x * y + z * w;

        if (test > 0.499 * unit) // singularity at north pole
        {
            return Math.PI * 0.5;
        }
        else if (test < -0.499 * unit) // singularity at south pole
        {
            return -Math.PI * 0.5;
        }
        else
        {
            return Math.asin(2.0 * test / unit);
        }
    }

    public function setFromAxisAngle(axis: Vector3, radians: Float): Void
    {
        axis.normalize();
        var halfAngle: Float = radians * 0.5;
        var s: Float = Math.sin(halfAngle);

        x = axis.x * s;
        y = axis.y * s;
        z = axis.z * s;
        w = Math.cos(halfAngle);
    }

    public function inverse(): Void
    {
        conjugate();
        normalize();
    }

    public function conjugate(): Void
    {
        x *= -1.0;
        y *= -1.0;
        z *= -1.0;
    }

    public function normalize(): Void
    {
        var length: Float = Quaternion.length(this);

        if (length == 0.0)
        {
            setIdentity();
        }
        else
        {
            multiplyScalar(1.0 / length);
        }
    }

    static public function dotProduct(left: Quaternion, right: Quaternion): Float
    {
        return left.x * right.x + left.y * right.y + left.z * right.z + left.w * right.w;
    }

    static public function length(quaternion: Quaternion): Float
    {
        return Math.sqrt(Quaternion.lengthSquared(quaternion));
    }

    static public function lengthSquared(quaternion: Quaternion): Float
    {
        return quaternion.x * quaternion.x + quaternion.y * quaternion.y + quaternion.z * quaternion.z + quaternion.w * quaternion.w;
    }

    public function multiply(q: Quaternion): Void
    {
        multiplyQuaternions(this, q);
    }

    // Multiplies two quaternions and stores the result in this
    // from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/code/index.htm

    public function multiplyQuaternions(left: Quaternion, right: Quaternion): Void
    {
        var qax = left.x, qay = left.y, qaz = left.z, qaw = left.w;
        var qbx = right.x, qby = right.y, qbz = right.z, qbw = right.w;

        x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
        y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
        z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
        w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;
    }

    public function add(quaternion: Quaternion): Void
    {
        x += quaternion.x;
        y += quaternion.y;
        z += quaternion.z;
        w += quaternion.w;
    }

    public function multiplyScalar(scalar: Float): Void
    {
        x *= scalar;
        y *= scalar;
        z *= scalar;
        w *= scalar;
    }

    public function isEqual(q: Quaternion): Bool
    {
        return q.x == x && q.y == y && q.z == z && q.w == w;
    }

    static public function slerp(qa: Quaternion, qb: Quaternion, qout: Quaternion, t: Float): Void
    {
        qout.set(qa);

        if (t == 0.0)
        {
            return;
        }
        if (t == 1.0)
        {
            qout.set(qb);
            return;
        }

        var x = qout.x, y = qout.y, z = qout.z, w = qout.w;

        var cosHalfTheta = w * qb.w + x * qb.x + y * qb.y + z * qb.z;

        if (cosHalfTheta < 0.0)
        {
            qout.w = -qb.w;
            qout.x = -qb.x;
            qout.y = -qb.y;
            qout.z = -qb.z;

            cosHalfTheta = -cosHalfTheta;
        }
        else
        {
            qout.set(qb);
        }

        if (cosHalfTheta >= 1.0)
        {
            qout.w = w;
            qout.x = x;
            qout.y = y;
            qout.z = z;

            return;
        }

        var halfTheta = Math.acos(cosHalfTheta);
        var sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);

        if (Math.abs(sinHalfTheta) < 0.001)
        {
            qout.w = 0.5 * (w + qout.w);
            qout.x = 0.5 * (x + qout.x);
            qout.y = 0.5 * (y + qout.y);
            qout.z = 0.5 * (z + qout.z);

            return;
        }

        var ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta;
        var ratioB = Math.sin(t * halfTheta) / sinHalfTheta;

        qout.w = (w * ratioA + qout.w * ratioB);
        qout.x = (x * ratioA + qout.x * ratioB);
        qout.y = (y * ratioA + qout.y * ratioB);
        qout.z = (z * ratioA + qout.z * ratioB);
    }

    public function toString(): String
    {
        return '[$x, $y, $z, $w]';
    }
}
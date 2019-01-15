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

import types.DualQuaternion;
class DualQuaternion
{
    public var real(default, null): Quaternion = null; // Rotation    (x, y, z, w)
    public var dual(default, null): Quaternion = null; // Translation (x, y, z, 0)

    static private var workingVectorA: Vector3 = new Vector3();
    static private var workingVectorB: Vector3 = new Vector3();
    static private var workingVectorC: Vector3 = new Vector3();
    static private var workingQuaternionA: Quaternion = new Quaternion();
    static private var workingQuaternionB: Quaternion = new Quaternion();
    static private var workingQuaternionC: Quaternion = new Quaternion();
    static private var workingDualQuaternionA: DualQuaternion = new DualQuaternion();
    static private var workingDualQuaternionB: DualQuaternion = new DualQuaternion();
    static private var workingDualQuaternionC: DualQuaternion = new DualQuaternion();

    public function new()
    {
        real = new Quaternion();
        real.setIdentity();
        dual = new Quaternion();
    }

    public function set(other: DualQuaternion): Void
    {
        other.real.normalize();
        real.set(other.real);
        dual.set(other.dual);
    }

    public function get(index: Int): Float
    {
        switch (index)
        {
            case 0: return real.x;
            case 1: return real.y;
            case 2: return real.z;
            case 3: return real.w;
            case 4: return dual.x;
            case 5: return dual.y;
            case 6: return dual.z;
            case 7: return dual.w;

            default: return 0.0;
        }
    }

    public function setFromQuaternions(real: Quaternion, dual: Quaternion): Void
    {
        real.normalize();
        this.real.set(real);
        this.dual.set(dual);
    }

    public function setIdentity(): Void
    {
        real.setIdentity();
        dual.setXYZW(0.0, 0.0, 0.0, 0.0);
    }

    public function setPositionAndRotation(position: Vector3, quaternion: Quaternion): Void
    {
        quaternion.normalize();
        real.set(quaternion);

        dual.setXYZW(position.x, position.y, position.z, 0.0);
        dual.multiply(real);
        dual.multiplyScalar(0.5);
    }

    public function setPosition(position: Vector3): Void
    {
        real.setIdentity();

        dual.setXYZW(position.x, position.y, position.z, 0.0);
        dual.multiply(real);
        dual.multiplyScalar(0.5);
    }

    public function setRotation(quaternion: Quaternion): Void
    {
        quaternion.normalize();
        real.set(quaternion);
        dual.setXYZW(0.0, 0.0, 0.0, 0.0);
    }

    public function setRotationX(radians: Float): Void
    {
        workingQuaternionA.setRotationX(radians);
        setRotation(workingQuaternionA);
    }

    public function setRotationY(radians: Float): Void
    {
        workingQuaternionA.setRotationY(radians);
        setRotation(workingQuaternionA);
    }

    public function setRotationZ(radians: Float): Void
    {
        workingQuaternionA.setRotationZ(radians);
        setRotation(workingQuaternionA);
    }

    public function getRotation(): Quaternion
    {
        return real;
    }

    public function getEulerRotation(out: Vector3): Void
    {
        real.getEulerRotation(out);
    }

    public function getTranslation(out: Vector3): Void
    {
        workingQuaternionB.set(dual);
        workingQuaternionC.set(real);
        workingQuaternionC.conjugate();
        workingQuaternionB.multiplyScalar(2.0);
        workingQuaternionA.multiplyQuaternions(workingQuaternionB, workingQuaternionC);
        out.x = workingQuaternionA.x;
        out.y = workingQuaternionA.y;
        out.z = workingQuaternionA.z;
    }

    public function setTranslation(translation: Vector3): Void
    {
        workingQuaternionA.setXYZW(translation.x, translation.y, translation.z, 0.0);
        dual.multiplyQuaternions(workingQuaternionA, real);
        dual.multiplyScalar(0.5);
    }

    public function multiplyScalar(scalar: Float): Void
    {
        real.multiplyScalar(scalar);
        real.normalize();
        dual.multiplyScalar(scalar);
    }

    public function multiply(q: DualQuaternion): Void
    {
        multiplyDualQuaternions(this, q);
    }

    // Multiplies two dual quaternions and stores the result in this

    public function multiplyDualQuaternions(q1: DualQuaternion, q2: DualQuaternion): Void
    {
        workingDualQuaternionA.set(q1);
        workingDualQuaternionB.set(q2);

        workingDualQuaternionA.normalize();
        workingDualQuaternionB.normalize();

        real.multiplyQuaternions(workingDualQuaternionA.real, workingDualQuaternionB.real);
        real.normalize();

        dual.multiplyQuaternions(workingDualQuaternionA.real, workingDualQuaternionB.dual);
        workingQuaternionA.multiplyQuaternions(workingDualQuaternionA.dual, workingDualQuaternionB.real);
        dual.add(workingQuaternionA);
    }

    public function add(q: DualQuaternion): Void
    {
        addDualQuaternion(this, q);
    }

    public function addDualQuaternion(q1: DualQuaternion, q2: DualQuaternion): Void
    {
        workingQuaternionA.set(q1.real);
        workingQuaternionA.add(q2.real);

        workingQuaternionB.set(q1.dual);
        workingQuaternionB.add(q2.dual);

        setFromQuaternions(workingQuaternionA, workingQuaternionB);
    }

    public function setFromAxisAngleAndTranslation(axis: Vector3, angle: Float, translation: Vector3): Void
    {
        real.setFromAxisAngle(axis, angle);
        real.normalize();

        dual.setXYZW(translation.x, translation.y, translation.z, 0.0);
        dual.multiply(real);
        dual.multiplyScalar(0.5);
    }

    public function setFromEulerAndTranslation(euler: Vector3, translation: Vector3): Void
    {
        real.setFromEuler(euler);
        real.normalize();

        dual.setXYZW(translation.x, translation.y, translation.z, 0.0);
        dual.multiply(real);
        dual.multiplyScalar(0.5);
    }

    public function normalize(): Void
    {
        var n: Float = 1.0 / Quaternion.length(real);
        real.multiplyScalar(n);
        dual.multiplyScalar(n);
    }

    public function conjugate(): Void
    {
        real.conjugate();
        dual.conjugate();
    }

    static public function dotProduct(left: DualQuaternion, right: DualQuaternion): Float
    {
        return Quaternion.dotProduct(left.real, right.real);
    }

    static public function sclerp(qa: DualQuaternion, qb: DualQuaternion, qout: DualQuaternion, t: Float): Void
    {
        var dot: Float = DualQuaternion.dotProduct(qa, qb);

        workingDualQuaternionA.set(qa);
        workingDualQuaternionA.conjugate();

        workingDualQuaternionB.set(qb);

        if (dot < 0.0)
        {
            workingDualQuaternionB.multiplyScalar(-1.0);
        }

        // diff
        workingDualQuaternionC.multiplyDualQuaternions(workingDualQuaternionA, workingDualQuaternionB);

        // vr
        workingVectorA.setXYZ(workingDualQuaternionC.real.x, workingDualQuaternionC.real.y, workingDualQuaternionC.real.z);
        // vd
        workingVectorB.setXYZ(workingDualQuaternionC.dual.x, workingDualQuaternionC.dual.y, workingDualQuaternionC.dual.z);

        var invr: Float = 1.0 / Math.sqrt(Vector3.lengthSquared(workingVectorA));

        var angle: Float = 2.0 * Math.acos(workingDualQuaternionC.real.w);
        var pitch: Float = -2.0 * workingDualQuaternionC.dual.w * invr;

        // direction
        workingVectorC.set(workingVectorA);
        workingVectorC.multiplyScalar(invr);

        // Reuse vr for Moment
        workingVectorA.set(workingVectorB);

        // Temp use of vd
        workingVectorB.set(workingVectorC);
        workingVectorB.multiplyScalar(pitch * workingDualQuaternionC.real.w * 0.5);
        workingVectorA.subtract(workingVectorB);

        workingVectorA.multiplyScalar(invr);

        angle *= t;
        pitch *= t;

        var sinAngle: Float = Math.sin(0.5 * angle);
        var cosAngle: Float = Math.cos(0.5 * angle);

        // We just need direction and moment from here

        // v
        workingVectorB.set(workingVectorC);
        workingVectorB.multiplyScalar(sinAngle);

        // real
        workingDualQuaternionC.real.setXYZW(workingVectorB.x, workingVectorB.y, workingVectorB.z, cosAngle);

        workingVectorA.multiplyScalar(sinAngle);
        workingVectorC.multiplyScalar(pitch * 0.5 * cosAngle);
        workingVectorA.add(workingVectorC);

        // dual
        workingDualQuaternionC.dual.setXYZW(workingVectorA.x, workingVectorA.y, workingVectorA.z, -pitch * 0.5 * sinAngle);

        qout.multiplyDualQuaternions(qa, workingDualQuaternionC);
    }

    public function toString(): String
    {
        return '[${real.x}, ${real.y}, ${real.z}, ${real.w}, ${dual.x}, ${dual.x}, ${dual.x}, ${dual.x}]';
    }
}

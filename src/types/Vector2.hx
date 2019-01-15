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

extern class Vector2
{
    public function new(_data: Data = null, _dataOffset: Int = 0): Void;

    /// Vector Interface

    public var x(get, set): Float;
    public var y(get, set): Float;

    /// Texture Coordinate Interface

    public var s(get, set): Float;
    public var t(get, set): Float;

    /// Setters & Getters

    public function setXY(_x: Float, _y: Float): Void;
    public function setST(_s: Float, _t: Float): Void;
    public function set(other: Vector2): Void;

    public function get(index: Int): Float;

    /// Math

    public function negate(): Void;

    public function add(right: Vector2): Void;
    public function subtract(right: Vector2): Void;
    public function multiply(right: Vector2): Void;
    public function divide(right: Vector2): Void;

    public function addScalar(value: Float): Void;
    public function subtractScalar(value: Float): Void;
    public function multiplyScalar(value: Float): Void;
    public function divideScalar(value: Float): Void;

    public function normalize(): Void;
    public function lerp(start: Vector2, end: Vector2, t: Float): Void;

    public static function length(vector: Vector2): Float;
    public static function lengthSquared(vector: Vector2): Float;
    public static function distance(start: Vector2, end: Vector2): Float;

    public static function dotProduct(left: Vector2, right: Vector2): Float;

    public function toString(): String;

    public var data(default, null): Data;
    public var dataOffset(default, null): Int;
}

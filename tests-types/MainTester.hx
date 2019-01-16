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

import types.haxeinterop.HaxeInputInteropStream;

import unittest.TestRunner;
import unittest.implementations.TestHTTPLogger;
import unittest.implementations.TestJUnitLogger;
import unittest.implementations.TestSimpleLogger;

import DataTest;
import Matrix4Test;
import Vector2Test;
import Vector4Test;
import SizeTest;
import AffineTransformTest;
import Color4BTest;
import Color4FTest;
import StreamTest;
import HaxeInteropTest;

import duellkit.DuellKit;

class MainTester
{
    static var r: TestRunner;

    static function main(): Void
    {
        DuellKit.initialize(start);
    }

    static function start(): Void
    {
        r = new TestRunner(testComplete, DuellKit.instance().onError);
        r.add(new AffineTransformTest());
        r.add(new Color4BTest());
        r.add(new Color4FTest());
        r.add(new DataTest());
        r.add(new DualQuaternionTest());
        r.add(new HaxeInteropTest());
        r.add(new Matrix3Test());
        r.add(new Matrix4Test());
        r.add(new QuaternionTest());
        r.add(new RectFTest());
        r.add(new RectITest());
        r.add(new SizeTest());
        r.add(new StreamTest());
        r.add(new Vector2Test());
        r.add(new Vector3Test());
        r.add(new Vector4Test());

        #if jenkins
            r.addLogger(new TestHTTPLogger(new TestJUnitLogger()));
        #else
            r.addLogger(new TestHTTPLogger(new TestSimpleLogger()));
        #end

        //if you run unittests on a device with android version < 5.0 use logger without http
        //r.addLogger(new TestSimpleLogger());

        r.run();
    }

    static function testComplete(): Void
    {
        trace(r.result);
    }
}

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

import types.DataType.DataTypeUtils;
import types.InputStream;

using types.DataStringTools;

import msignal.Signal;

class DataInputStream implements InputStream
{
    public var onDataAvailable(default, null): Signal1<InputStream>;

    /// not necessarily the full extent of the stream
    public var bytesAvailable(get, null): Int;

    /// STATE
    public var onEndOfStream(default, null): Signal1<InputStream>;
    public var onOpen(default, null): Signal1<InputStream>;
    public var onClose(default, null): Signal1<InputStream>;

    /// ERROR
    public var errorCode(default, null): Null<Int>;
    public var errorMessage(default, null): String;
    public var onError(default, null): Signal1<InputStream>;

    private var openned: Bool;
    private var data: Data;
    private var currentOffset: Int;

    /// CONTROL METHODS

    public function open(): Void
    {
        openned = true;
        onOpen.dispatch(this);
    }

    public function close(): Void
    {
        openned = false;
        data = null;
        onClose.dispatch(this);
    }

    public function isOpen(): Bool
    {
        return openned;
    }

    public function skip(byteCount: Int): Void
    {
        currentOffset += byteCount;
    }

    public function new(newData: Data): Void
    {
        onDataAvailable = new Signal1();
        onEndOfStream = new Signal1();
        onError = new Signal1();
        onOpen = new Signal1();
        onClose = new Signal1();
        onReadData = new Signal2();

        reset(newData);
    }

    public function reset(newData: Data): Void
    {
        if (isOpen())
        {
            close();
        }

        openned = false;
        data = newData;
        currentOffset = data.offset;
    }

    /// READING METHOD
    /// if async, it will reply on "onReadData"
    public var onReadData(default, null): Signal2<InputStream, Data>;

    public function readIntoData(receivingData: Data): Void
    {
        var prevOffset = data.offset;
        var prevLength = data.offsetLength;
        data.offset = currentOffset;
        data.offsetLength = receivingData.offsetLength;
        receivingData.writeData(data);
        currentOffset += receivingData.offsetLength;
        data.offset = prevOffset;
        data.offsetLength = prevLength;

        checkEndOfStream();
    }

    public function isOnEndOfStream(): Bool
    {
        return true; /// we always have the full extent of the readable data
    }

    private function checkEndOfStream(): Void
    {
        if (get_bytesAvailable() > 0)
            return;

        onEndOfStream.dispatch(this);
    }

    private function get_bytesAvailable(): Int
    {
        return data.offsetLength - currentOffset;
    }

    /// if async, all read operations will return immediately
    /// can be different per stream subclass, and even within platforms on the same stream class

    public function isAsync(): Bool
    {
        return false;
    }
}

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

import msignal.Signal;

interface InputStream
{
    /// If the stream's bytes available is not changed behind the scenes
    /// then they do not have to call this signal
    public var onDataAvailable(default, null): Signal1<InputStream>;

    /// not necessarily the full extent of the stream
    public var bytesAvailable(get, null): Int;

    /// STATE
    /// if it starts on end of stream, this is never called
    public var onEndOfStream(default, null): Signal1<InputStream>;

    public var onOpen(default, null): Signal1<InputStream>;
    public var onClose(default, null): Signal1<InputStream>;
    /// is true if the bytes available is the total ammount left on the stream
    public function isOnEndOfStream(): Bool;

    /// CONTROL METHODS
    public function open(): Void;
    public function close(): Void;
    public function isOpen(): Bool;

    public function skip(byteCount: Int): Void;

    /// READING METHOD
    /// if async, it will reply on "onReadData"
    public function readIntoData(data: Data): Void;
    public var onReadData(default, null): Signal2<InputStream, Data>;

    /// if async, all read operations will return immediately
    /// can be different per stream subclass, and even within platforms on the same stream class
    public function isAsync(): Bool;

    /// ERROR
    public var errorCode(default, null): Null<Int>;
    public var errorMessage(default, null): String;
    public var onError(default, null): Signal1<InputStream>;
}

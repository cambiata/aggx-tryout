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
import types.OutputStream;

using types.DataStringTools;

import msignal.Signal;

class DataOutputStream implements OutputStream
{
    public var onError(default, null): Signal1<OutputStream>;
    public var onOpen(default, null): Signal1<OutputStream>;
    public var onClose(default, null): Signal1<OutputStream>;

    public var errorCode(default, null): Null<Int>;
    public var errorMessage(default, null): String;

    private var openned: Bool;
    private var data: Data;
    private var currentOffset: Int;
    private var currentOffsetLength: Int;
    private var resize: Bool;

    public function new(newData: Data, resize: Bool = false): Void
    {
        onDataWriteFinished = new Signal2();
        onError = new Signal1();
        onOpen = new Signal1();
        onClose = new Signal1();

        reset(newData, resize);
    }

    public function reset(newData: Data, resize: Bool = false): Void
    {
        if (isOpen())
        {
            close();
        }

        openned = false;
        this.resize = resize;
        data = newData;
        currentOffset = data.offset;
        currentOffsetLength = 0;
        data.offsetLength = currentOffsetLength;
    }

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

    /// WRITING METHODS
    public var onDataWriteFinished(default, null): Signal2<InputStream, Data>;

    public function writeData(sourceData: Data): Void
    {
        if (resize)
        {
            var size: Int = (currentOffset + sourceData.offsetLength) - data.allocedLength;
            if (size > 0)
            {
                grow(data.allocedLength + size);
            }
        }

        var prevOffset = data.offset;
        data.offset = currentOffset;
        data.writeData(sourceData);
        currentOffset += sourceData.offsetLength;
        data.offset = prevOffset;
        data.offsetLength += sourceData.offsetLength;
    }

    /// always grows by 1.5

    private function grow(minCapacity: Int)
    {
        var oldCapacity = data.allocedLength;
        var newCapacity = oldCapacity + (oldCapacity >> 1);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;

        // minCapacity is usually close to size, so this is a win:
        data.resize(minCapacity);
    }

    public function isAsync(): Bool
    {
        return false;
    }

}

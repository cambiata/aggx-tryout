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

package types.haxeinterop;

import haxe.io.Eof;
import haxe.io.Bytes;
import haxe.io.Input;

using types.haxeinterop.DataBytesTools;

class HaxeInputInteropStream extends Input
{
    private var inputStream: InputStream;
    private var workingData: Data;
    public function new(newInputStream : InputStream)
    {
        #if debug
        if (newInputStream.isAsync())
        {
            throw "HaxeInputInteropStream only works with sync streams";
        }
        #end

        workingData = new Data(8);
        inputStream = newInputStream;
        bigEndian = false;
    }

    override function readByte() : Int
    {
        workingData.offsetLength = 1;
        inputStream.readIntoData(workingData);
        return workingData.readInt(DataTypeUInt8);
    }

    override function readBytes( s : Bytes, pos : Int, len : Int ) : Int
    {
        workingData.offsetLength = 1;
        for(i in 0...len)
        {
            inputStream.readIntoData(workingData);
            s.set(pos + i, workingData.readInt(DataTypeUInt8));
        }
        return len;
    }

    override function readInt16()
    {
        workingData.offsetLength = 2;
        inputStream.readIntoData(workingData);
        return workingData.readInt(DataTypeInt16);
    }

    override function readDouble() : Float {
        workingData.offsetLength = 8;
        inputStream.readIntoData(workingData);
        return workingData.readFloat(DataTypeFloat64);
    }
}

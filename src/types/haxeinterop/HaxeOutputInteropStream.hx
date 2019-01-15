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
import haxe.io.Input;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.io.Error;
class HaxeOutputInteropStream extends Output
{
    private var outputStream : OutputStream;
    private var workingData: Data;
    public function new(newOutputStream : OutputStream)
    {
        #if debug
        if (newOutputStream.isAsync())
        {
            throw "HaxeOutputInteropStream only works with sync streams";
        }
        #end
        workingData = new Data(8);
        outputStream = newOutputStream;
        bigEndian = false;
    }

    override function writeByte( c : Int ) : Void
    {
        workingData.offsetLength = 1;
        workingData.writeInt(c, DataTypeUInt8);
        outputStream.writeData(workingData);
    }

    override function writeBytes( s : Bytes, pos : Int, len : Int ) : Int
    {
        for(i in 0...len)
        {
            writeByte(s.get(pos + i));
        }
        return len;
    }

    override function flush()
    {

    }

    override function close()
    {
        outputStream.close();
    }

}

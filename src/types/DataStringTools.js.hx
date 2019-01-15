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

class DataStringTools {
	public static function readString(data:Data):String {
		// return new js.html.TextDecoder().decode(data.arrayBuffer);
		return decodeArrayBuffer(data.arrayBuffer);
	}

	public static function writeString(data:Data, string:String):Void {
		// data.uint8Array.set(new js.html.TextEncoder().encode(string), data.offset);
		data.uint8Array.set(encodeToUint8Array(string), data.offset);
	}

	public static function sizeInBytes(string:String) {
		var byteLen = 0;

		for (i in 0...string.length) {
			var c = string.charCodeAt(i);
			byteLen += c < (1 << 7) ? 1 : c < (1 << 11) ? 2 : c < (1 << 16) ? 3 : c < (1 << 21) ? 4 : c < (1 << 26) ? 5 : c < (1 << 31) ? 6 : 0;
		}

		return byteLen;
	}

	//-------------------------------------------------
	static public function decodeArrayBuffer(buffer:js.html.ArrayBuffer):String {
		var bytes = new js.html.Uint8Array(buffer);
		var pos = 0;
		var len = bytes.length;
		trace(len);
		var out = [];

		while (pos < len) {
			var byte1 = bytes[pos++];
			if (byte1 == 0) {
				break; // NULL
			}

			if ((byte1 & 0x80) == 0) { // 1-byte
				out.push(byte1);
			} else if ((byte1 & 0xe0) == 0xc0) { // 2-byte
				var byte2 = bytes[pos++] & 0x3f;
				out.push(((byte1 & 0x1f) << 6) | byte2);
			} else if ((byte1 & 0xf0) == 0xe0) {
				var byte2 = bytes[pos++] & 0x3f;
				var byte3 = bytes[pos++] & 0x3f;
				out.push(((byte1 & 0x1f) << 12) | (byte2 << 6) | byte3);
			} else if ((byte1 & 0xf8) == 0xf0) {
				var byte2 = bytes[pos++] & 0x3f;
				var byte3 = bytes[pos++] & 0x3f;
				var byte4 = bytes[pos++] & 0x3f;

				// this can be > 0xffff, so possibly generate surrogates
				var codepoint = ((byte1 & 0x07) << 0x12) | (byte2 << 0x0c) | (byte3 << 0x06) | byte4;
				if (codepoint > 0xffff) {
					// codepoint &= ~0x10000;
					codepoint -= 0x10000;
					out.push((codepoint >>> 10) & 0x3ff | 0xd800);
					codepoint = 0xdc00 | codepoint & 0x3ff;
				}
				out.push(codepoint);
			} else {
				// FIXME: we're ignoring this
			}
		}

		var result = '';
		for (i in 0...out.length) {
			result += String.fromCharCode(out[i]);
		}
		return result;
	}

	static public function encodeToUint8Array(string:String):js.html.Uint8Array {
		var pos = 0;
		var len = string.length;
		var at = 0; // output position
		var tlen:Int = cast Math.max(32, len + (len >> 1) + 7); // 1.5x size

		var target = new js.html.Uint8Array((tlen >> 3) << 3); // ... but at 8 byte offset

		while (pos < len) {
			var value = string.charCodeAt(pos++);
			if (value >= 0xd800 && value <= 0xdbff) {
				// high surrogate
				if (pos < len) {
					var extra = string.charCodeAt(pos);
					if ((extra & 0xfc00) == 0xdc00) {
						++pos;
						value = ((value & 0x3ff) << 10) + (extra & 0x3ff) + 0x10000;
					}
				}
				if (value >= 0xd800 && value <= 0xdbff) {
					continue; // drop lone surrogate
				}
			}

			// expand the buffer if we couldn't write 4 bytes
			if (at + 4 > target.length) {
				tlen += 8; // minimum extra
				tlen *= cast(1.0 + (pos / string.length) * 2); // take 2x the remaining
				tlen = (tlen >> 3) << 3; // 8 byte offset

				var update = new js.html.Uint8Array(tlen);
				update.set(target);
				target = update;
			}

			if ((value & 0xffffff80) == 0) { // 1-byte
				target[at++] = value; // ASCII
				continue;
			} else if ((value & 0xfffff800) == 0) { // 2-byte
				target[at++] = ((value >> 6) & 0x1f) | 0xc0;
			} else if ((value & 0xffff0000) == 0) { // 3-byte
				target[at++] = ((value >> 12) & 0x0f) | 0xe0;
				target[at++] = ((value >> 6) & 0x3f) | 0x80;
			} else if ((value & 0xffe00000) == 0) { // 4-byte
				target[at++] = ((value >> 18) & 0x07) | 0xf0;
				target[at++] = ((value >> 12) & 0x3f) | 0x80;
				target[at++] = ((value >> 6) & 0x3f) | 0x80;
			} else {
				// FIXME: do we care
				continue;
			}

			target[at++] = (value & 0x3f) | 0x80;
		}

		return target.slice(0, at);
	}
}

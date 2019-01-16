import aggx.rasterizer.IScanline;
import aggx.renderer.IRenderer;
import aggx.color.RgbaColor;
import aggx.renderer.SolidScanlineRenderer;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.rasterizer.Scanline;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.RenderingBuffer;
import aggx.typography.FontEngine;
import aggx.rfpx.TrueTypeCollection;
import haxe.io.Bytes;
import haxe.Resource;
import types.DataStringTools;
import types.Data;
import haxe.Http;
import aggx.rfpx.TrueTypeLoader;
import vectorx.font.FontContext;
import vectorx.font.FontCache;
import vectorx.font.Font;
import vectorx.ColorStorage;
import aggx.core.memory.MemoryAccess;

using aggx.core.memory.RgbaReaderWriter;

class ExampleVectorx {
	static public function main() {
		//-----------------------------------------------
		// Load a ttf font as a Haxe resource
		// (Avoiding Gameduell's multiplatform filesystem infrastructure)
		var url = 'arial.ttf';
		var bytes:Bytes = Resource.getBytes(url);
		var bytesData:haxe.io.BytesData = bytes.getData();

		//-----------------------------------------------
		// Create a Data instance containing the font data
		// (Data is Gameduell's core data type)

		#if js
		var ttfData:Data = new Data(bytesData.byteLength);
		ttfData.set_arrayBuffer(bytesData);
		#elseif flash
		var ttfData:Data = new Data(bytesData.length);
		ttfData.byteArray = bytesData;
		#end

		var fontCache:FontCache = new FontCache(ttfData);
		var fontContext:FontContext = new FontContext();
		var font:Font = fontCache.createFontWithNameAndSize("Arial", 35.0);

		var attachmentColorStorage:ColorStorage = renderAttachment();
	}

	static function renderAttachment():ColorStorage {
		var colorStorage:ColorStorage = new ColorStorage(70, 70);

		MemoryAccess.select(colorStorage.data);
		var rbuf:RenderingBuffer = new RenderingBuffer(colorStorage.width, colorStorage.height, ColorStorage.COMPONENTS * colorStorage.width);

		for (i in 2...63) {
			var row = rbuf.getRowPtr(i);
			for (j in 2...63) {
				var ptr = row + j * ColorStorage.COMPONENTS;
				if ((j + i) % 5 != 0) {
					ptr.setFull(255, 255, 255, 128);
				} else {
					ptr.setFull(255, 0, 0, 255);
				}
			}
		}

		MemoryAccess.select(null);
		return colorStorage;
	}
}

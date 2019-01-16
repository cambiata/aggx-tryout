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
import vectorx.font.StringAttributes;
import vectorx.font.AttributedString;
import vectorx.font.AttributedRange;
import vectorx.font.FontAttachment;
import vectorx.font.FontContext;
import vectorx.font.FontCache;
import vectorx.font.Font;
import vectorx.ColorStorage;
import aggx.core.memory.MemoryAccess;
import haxe.ds.StringMap;
import types.Color4F;
import types.VerticalAlignment;
import types.HorizontalAlignment;
import vectorx.font.LayoutBehaviour;

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

		//---------------------------------------------------------------
		// Example code from
		// vectorx-master/examples/source/tests/fontTest/FontTest.hx

		var fontCache:FontCache = new FontCache(ttfData);
		var fontContext:FontContext = new FontContext();
		var font:Font = fontCache.createFontWithNameAndSize("Arial", 35.0);

		var attachmentColorStorage:ColorStorage = renderAttachment();
		var attachment = new FontAttachment(function() {
			return attachmentColorStorage;
		}, 0, 0, 70, 32);

		var red:Color4F = new Color4F();
		red.setRGBA(1, 0, 0, 1);

		var attachments:StringMap<FontAttachment> = ["a1" => attachment];
		var stringAttributes:StringAttributes = {
			range: new AttributedRange(),
			font: font,
			backgroundColor: red,
			attachmentId: "a1"
		};

		// var string0 = "QabcdefghjiklmnopqrstuvwxyzabcdefghjiklmnopqrstuvwxyzabcdefghjiklmnopqrstuvwxyzabcdefghjiklmnopqrstuvwxyzabcdefghjiklmnopqrstuvwxyzQ";
		var string0 = 'Hello world!';

		var attributedString:AttributedString = new AttributedString(string0, stringAttributes);

		var pixelBufferWidth:UInt = 500;
		var pixelBufferHeight:UInt = 500;
		var colorStorage:ColorStorage = new ColorStorage(pixelBufferWidth, pixelBufferHeight);
		var data:Data = colorStorage.data;
		colorStorage.selectedRect.x = 30;
		colorStorage.selectedRect.y = 100;
		colorStorage.selectedRect.width = 200;
		colorStorage.selectedRect.height = 300;

		var layoutConfig:TextLayoutConfig = {
			scale: 1,
			horizontalAlignment: HorizontalAlignment.Center,
			verticalAlignment: VerticalAlignment.Top,
			layoutBehaviour: LayoutBehaviour.AlwaysFit
		};
		trace(layoutConfig);

		var attachmentResolver = (id:String, ratio:Float) -> {
			return attachments.get(id);
		};

		var layout = fontContext.calculateTextLayout(attributedString, colorStorage.selectedRect, layoutConfig, attachmentResolver);
		trace(layout);

		fontContext.renderStringToColorStorage(layout, colorStorage);
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

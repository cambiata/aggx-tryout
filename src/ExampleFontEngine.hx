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

class ExampleFontEngine {
	static public function main() {
		//-----------------------------------------------
		// Load a ttf font as a Haxe resource
		// (Avoiding Gameduell's multiplatform filesystem infrastructure)

		var url = 'Pacifico.ttf';
		var bytes:Bytes = Resource.getBytes(url);
		var bytesData:haxe.io.BytesData = bytes.getData();

		//-----------------------------------------------
		// Create a Data instance containing the font data
		// (Data is Gameduell's core data type)

		#if js
		var data:Data = new Data(bytesData.byteLength);
		data.set_arrayBuffer(bytesData);
		#elseif flash
		var data:Data = new Data(bytesData.length);
		data.byteArray = bytesData;
		#end

		//-------------------------------------------------
		// Instantiate a TrueTypeLoader and load a
		// TrueTypeCollection out of it
		var ttl = new TrueTypeLoader(data);
		ttl.load((ttc:TrueTypeCollection) -> {
			trace(ttc.fontCount); // 1
			trace(ttc.getFontName()); // Pacifico

			//-------------------------------------------------
			// Instantiate the FontEngine
			var fontEngine = new FontEngine(ttc);
			var fontSize = 80;

			//-------------------------------------------------
			// Instantiate a TestRenderer (see below) just to get something through.
			// (Avoding the use of native platform stuff, OpenGL etc here.)
			var renderer:TestRenderer = new TestRenderer();

			// Render a string
			var x = 10;
			var y = 0 * fontSize / 20;
			fontEngine.renderString('Hello world!', fontSize, x, y, renderer);
		});
	}
}

class TestRenderer implements IRenderer {
	public function new() {}

	public function prepare():Void {
		trace('TestRenderer.prepare ///////////////////////////');
	}

	public function render(sl:IScanline):Void {
		trace('TestRenderer.render ----------------------------');
		trace('spanCount: ' + sl.spanCount);
		trace(sl);
	}
}

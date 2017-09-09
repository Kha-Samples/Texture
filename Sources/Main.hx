package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.Scheduler;
import kha.Shaders;
import kha.System;
import kha.graphics4.ConstantLocation;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.math.FastMatrix3;

class Main {
	static var pipeline: PipelineState;
	static var vertices: VertexBuffer;
	static var indices: IndexBuffer;
	static var texture: Image;
	static var texunit: TextureUnit;
	static var offset: ConstantLocation;
	
	public static function main(): Void {
		System.init({title: "TextureTest", width: 1024, height: 768}, function () {
				Assets.loadEverything(function () {
				var structure = new VertexStructure();
				structure.add("pos", VertexData.Float3);
				structure.add("tex", VertexData.Float2);
				
				pipeline = new PipelineState();
				pipeline.inputLayout = [structure];
				pipeline.vertexShader = Shaders.texture_vert;
				pipeline.fragmentShader = Shaders.texture_frag;
				pipeline.compile();

				texunit = pipeline.getTextureUnit("texsampler");
				offset = pipeline.getConstantLocation("mvp");
				
				vertices = new VertexBuffer(3, structure, Usage.StaticUsage);
				var v = vertices.lock();
				v.set( 0, -1); v.set( 1, -1); v.set( 2, 0.5); v.set( 3, 0); v.set( 4, 1);
				v.set( 5,  1); v.set( 6, -1); v.set( 7, 0.5); v.set( 8, 1); v.set( 9, 1);
				v.set(10, -1); v.set(11,  1); v.set(12, 0.5); v.set(13, 0); v.set(14, 0);
				vertices.unlock();
				
				indices = new IndexBuffer(3, Usage.StaticUsage);
				var i = indices.lock();
				i[0] = 0; i[1] = 1; i[2] = 2;
				indices.unlock();
				
				System.notifyOnRender(render);
			});
		});
	}
	
	private static function render(frame: Framebuffer): Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.Black);
		g.setPipeline(pipeline);
		g.setMatrix3(offset, FastMatrix3.rotation(Scheduler.realTime()));
		g.setTexture(texunit, Assets.images.parrot);
		g.setVertexBuffer(vertices);
		g.setIndexBuffer(indices);
		g.drawIndexedVertices();
		g.end();
	}
}

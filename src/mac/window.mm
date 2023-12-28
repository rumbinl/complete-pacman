#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

float triangle[] = {
	-300, 220, 0.0f, 0.0f,
	-300, -220, 0.0f, 1.0f,
	300, 220, 1.0f, 0.0f,
	300, -220, 1.0f, 1.0f,
};

int indices[] = {
	0, 1, 2,
	2, 1, 3
};

float viewportSize[] = {
	640,480
};

const int texWidth = 224, texHeight = 248;

uint32_t texture[texWidth*texHeight];

void render(MTKView* view, id<MTLCommandQueue> commandQueue, id<MTLRenderPipelineState> pipeline, id<MTLTexture> tex)
{
	@autoreleasepool {

		MTLRenderPassDescriptor* renderPass = [view currentRenderPassDescriptor];
		id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
		id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor: renderPass];
		[commandEncoder setViewport:(MTLViewport){0.0, 0.0, view.drawableSize.width, view.drawableSize.height, 0.0, 1.0}];
		[commandEncoder setRenderPipelineState: pipeline];
		[commandEncoder setVertexBytes:triangle length:sizeof(triangle) atIndex:0];
		[commandEncoder setVertexBytes:indices length:sizeof(indices) atIndex:1];
		[commandEncoder setVertexBytes:viewportSize length:sizeof(viewportSize) atIndex:2];
		[commandEncoder setFragmentTexture: tex atIndex: 0];

		[commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
		[commandEncoder endEncoding];
		id<MTLDrawable> drawable = view.currentDrawable;
		[commandBuffer presentDrawable: drawable];
		[commandBuffer commit];
	}
}

id<MTLTexture> createTexture(uint32_t* tex, int width, int height, id<MTLDevice> device)
{
	MTLTextureDescriptor* textureDescriptor = [[MTLTextureDescriptor alloc]init];
	textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
	textureDescriptor.width = width;
	textureDescriptor.height = height;

	id<MTLTexture> result = [device newTextureWithDescriptor: textureDescriptor];
	MTLRegion region = {0, 0, 0, width, height, 1};
	[result replaceRegion: region mipmapLevel:0 withBytes:tex bytesPerRow: 4 * width];
	return result;
}

int main()
{
	for(int i=0;i<texWidth*texHeight; i++)
		texture[i] = 0xff000000;
	texture[0] = 0xff2121ff;

	NSRect contentRect = NSMakeRect(0, 0, 640, 480);
	NSWindowStyleMask styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
	NSWindow* window = [[NSWindow alloc] initWithContentRect:contentRect styleMask: styleMask backing: NSBackingStoreBuffered defer: true];
	[[window contentView]initWithFrame: contentRect];
	[window makeKeyAndOrderFront: nil];

	id<MTLDevice> device = MTLCreateSystemDefaultDevice();
	NSError* error = nil;

	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);
	
	id<MTLCommandQueue> commandQueue = [device newCommandQueue];
	MTKView* view = [[MTKView alloc]initWithFrame:contentRect device:device];

	[view setClearColor: MTLClearColorMake(0.0f, 0.0f, 0.0f,1.0f)];
	[view setColorPixelFormat:MTLPixelFormatBGRA8Unorm];
	[view setDepthStencilPixelFormat:MTLPixelFormatDepth32Float];
	[view setNeedsDisplay: YES];

	view.framebufferOnly = false;

	MTLCompileOptions* compileOptions = [[MTLCompileOptions alloc] init];
	NSString* source = [[NSString alloc] initWithContentsOfFile:@"./shaders.metal" encoding: NSUTF8StringEncoding error: &error];

	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);

	id<MTLLibrary> library = [device newLibraryWithSource: source options:compileOptions error:&error];
	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);
	id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader"];
	id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"samplingShader"];

	MTLRenderPipelineDescriptor* pipeline = [[MTLRenderPipelineDescriptor alloc] init];
	pipeline.label = @"Pipeline";
	pipeline.vertexFunction = vertexFunction;
	pipeline.fragmentFunction = fragmentFunction;
	pipeline.colorAttachments[0].pixelFormat = view.colorPixelFormat;
	
	id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor: pipeline error: &error];

	id<MTLTexture> tex = createTexture(texture, texWidth, texHeight, device);
	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);


	[window setContentView: view];
	render(view, commandQueue, pipelineState, tex);

	while([window isVisible])
	{
		NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantPast] inMode:NSDefaultRunLoopMode dequeue:YES];
	
		if(event!=nil)
			[NSApp sendEvent:event];
	}

	return 0;
}

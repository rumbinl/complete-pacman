#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

#include <mac/PM_MetalWindow.h>
#include <mac/PM_MetalTexture.h>

float triangle[] = {
	-1, 1, 0.0f, 0.0f,
	-1, -1, 0.0f, 1.0f,
	1, 1, 1.0f, 0.0f,
	1, -1, 1.0f, 1.0f,
};

int indices[] = {
	0, 1, 2,
	2, 1, 3
};

int viewportSize[] = {
	0,0
};

const int texWidth = 224, texHeight = 248;

int texSize[] = {
	texWidth, texHeight	
};

uint32_t texture[texWidth*texHeight];

void render(MTKView* view, id<MTLCommandQueue> commandQueue, id<MTLRenderPipelineState> pipeline, id<MTLTexture> tex)
{
	@autoreleasepool {
		PM_SetMetalTextureContents(tex, texture, texWidth, texHeight);

		MTLRenderPassDescriptor* renderPass = view.currentRenderPassDescriptor;
		id<CAMetalDrawable> drawable = ((CAMetalLayer*)view.currentDrawable.layer).nextDrawable;

		renderPass.colorAttachments[0].texture = drawable.texture;
		renderPass.colorAttachments[0].loadAction = MTLLoadActionClear;
		renderPass.colorAttachments[0].storeAction = MTLStoreActionStore;

		id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
		id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor: renderPass];

		viewportSize[0] = view.drawableSize.width;
		viewportSize[1] = view.drawableSize.height;

		[commandEncoder setViewport:(MTLViewport){0.0, 0.0, view.drawableSize.width, view.drawableSize.height, 0.0, 1.0}];
		[commandEncoder setRenderPipelineState: pipeline];
		[commandEncoder setVertexBytes:triangle length:sizeof(triangle) atIndex:0];
		[commandEncoder setVertexBytes:indices length:sizeof(indices) atIndex:1];
		[commandEncoder setVertexBytes:viewportSize length:sizeof(viewportSize) atIndex:2];
		[commandEncoder setVertexBytes:texSize length:sizeof(texSize) atIndex:3];
		[commandEncoder setFragmentTexture: tex atIndex: 0];
		[commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
		[commandEncoder endEncoding];

		[commandBuffer presentDrawable: (id<MTLDrawable>) drawable];
		[commandBuffer commit];
	}
}

int main()
{
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
	pipeline.label = @"pipeline";
	pipeline.vertexFunction = vertexFunction;
	pipeline.fragmentFunction = fragmentFunction;
	pipeline.colorAttachments[0].pixelFormat = view.colorPixelFormat;
	
	id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor: pipeline error: &error];

	id<MTLTexture> tex = PM_CreateMetalTexture(texWidth, texHeight, device);

	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);

	[window setContentView: view];

	while([window isVisible])
	{
		texture[arc4random_uniform(texWidth*texHeight)] = 0xffff0000;
		render(view, commandQueue, pipelineState, tex);
		NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantFuture] inMode:NSDefaultRunLoopMode dequeue:YES];
	
		if(event!=nil)
			[NSApp sendEvent:event];
	}

	return 0;
}

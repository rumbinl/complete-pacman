#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

float triangle[] = {
	-340, 240,
	-340, -240,
	340, 240, 
	340, 240,
	340, -240,
	-340, -240	
};

float viewportSize[] = {
	640,480
};

void render(MTKView* view, id<MTLCommandQueue> commandQueue, id<MTLRenderPipelineState> pipeline)
{
	@autoreleasepool {

		MTLRenderPassDescriptor* renderPass = [view currentRenderPassDescriptor];
		id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
		id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor: renderPass];
		[commandEncoder setViewport:(MTLViewport){0.0, 0.0, view.drawableSize.width, view.drawableSize.height, 0.0, 1.0}];
		[commandEncoder setRenderPipelineState: pipeline];
		[commandEncoder setVertexBytes:triangle length:sizeof(triangle) atIndex:0];
		[commandEncoder setVertexBytes:viewportSize length:sizeof(viewportSize) atIndex:1];

		[commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
		[commandEncoder endEncoding];
		id<MTLDrawable> drawable = view.currentDrawable;
		[commandBuffer presentDrawable: drawable];
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
	id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader"];
	id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragmentShader"];

	MTLRenderPipelineDescriptor* pipeline = [[MTLRenderPipelineDescriptor alloc] init];
	pipeline.label = @"Pipeline";
	pipeline.vertexFunction = vertexFunction;
	pipeline.fragmentFunction = fragmentFunction;
	pipeline.colorAttachments[0].pixelFormat = view.colorPixelFormat;
	
	id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor: pipeline error: nil];

	[window setContentView: view];
	render(view, commandQueue, pipelineState);

	while([window isVisible])
	{
		NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantPast] inMode:NSDefaultRunLoopMode dequeue:YES];
	
		if(event!=nil)
			[NSApp sendEvent:event];
	}

	return 0;
}

#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

void render(MTKView* view, id<MTLCommandQueue> commandQueue)
{
	@autoreleasepool {

		MTLRenderPassDescriptor* renderPass = [view currentRenderPassDescriptor];
		id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
		id<MTLCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor: renderPass];
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
	NSBackingStoreType backingStoreType = NSBackingStoreBuffered;

	NSWindow* window = [[NSWindow alloc]initWithContentRect:contentRect styleMask: styleMask backing: backingStoreType defer: true];
	[[window contentView]initWithFrame: contentRect];

	[window makeKeyAndOrderFront: nil];

	id<MTLDevice> device = MTLCreateSystemDefaultDevice();
	id<MTLCommandQueue> commandQueue = [device newCommandQueue];
	MTKView* view = [[MTKView alloc]initWithFrame:contentRect device:device];

	[view setClearColor: MTLClearColorMake(0.0f, 0.0f, 0.0f,1.0f)];
	[view setColorPixelFormat:MTLPixelFormatBGRA8Unorm];
	[view setDepthStencilPixelFormat:MTLPixelFormatDepth32Float];
	[view setNeedsDisplay: YES];

	view.framebufferOnly = false;

	[window setContentView: view];
	[window makeFirstResponder: view];
	render(view, commandQueue);
	[view setClearColor: MTLClearColorMake(0.0f, 0.0f, 1.0f,1.0f)];
	render(view, commandQueue);
//	[window display];

	while([window isVisible])
	{
		NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantPast] inMode:NSDefaultRunLoopMode dequeue:YES];
	
		if(event!=nil)
			[NSApp sendEvent:event];
	}

	return 0;
}

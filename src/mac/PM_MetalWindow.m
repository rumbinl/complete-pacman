#include <mac/PM_MetalWindow.h>

PM_MetalWindowState PM_CreateMetalWindow(unsigned int windowWidth, unsigned int windowHeight)
{
	PM_MetalWindowState windowContext;

	NSRect contentRect = {0, 0, windowWidth, windowHeight};
	NSWindowStyleMask styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;

	windowContext.cocoaWindow = [[NSWindow alloc] initWithContentRect:contentRect styleMask: styleMask backing: NSBackingStoreBuffered defer: true];
	[windowContext.cocoaWindow makeKeyAndOrderFront: nil];

	windowContext.metalView = [[MTKView alloc]initWithFrame:contentRect device: MTLCreateSystemDefaultDevice()];

	[windowContext.metalView setClearColor: MTLClearColorMake(0.0f, 0.0f, 0.0f,1.0f)];
	[windowContext.metalView setColorPixelFormat:MTLPixelFormatBGRA8Unorm];
	[windowContext.metalView setDepthStencilPixelFormat:MTLPixelFormatDepth32Float];
	[windowContext.metalView setNeedsDisplay: YES];

	windowContext.metalView.framebufferOnly = false;

	windowContext.renderDelegate = [[PM_MetalRenderer alloc] initWithMTKView: windowContext.metalView];
	windowContext.metalView.delegate = windowContext.renderDelegate;

	[windowContext.cocoaWindow setContentView: windowContext.metalView];

	return windowContext;
}

void PM_RunMetalLoop(PM_WindowContext windowContext)
{
	while([(*(PM_MetalWindowState*)windowContext.metalWindowState).cocoaWindow isVisible])
	{
		[(*(PM_MetalWindowState*)windowContext.metalWindowState).renderDelegate setMetalTexture: windowContext.framebuffer];
		NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantFuture] inMode: NSDefaultRunLoopMode dequeue: YES];
	
		if(event != nil)
			[NSApp sendEvent: event];	
	}
}

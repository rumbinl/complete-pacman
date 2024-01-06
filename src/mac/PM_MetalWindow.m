#include <mac/PM_MetalRenderer.h>
#include <window/PM_WindowContext.h>

#ifdef __APPLE__
PM_WindowContext PM_CreateWindowContext(unsigned int windowWidth, unsigned int windowHeight)
{
	PM_WindowContext windowContext;

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

	windowContext.framebuffer = PM_CreateBlankImage(PM_FRAMEBUFFER_WIDTH, PM_FRAMEBUFFER_HEIGHT);
	PM_ClearImageWithColor(windowContext.framebuffer, 0xffffffff);
	
	return windowContext;
}

void PM_RunLoop(PM_WindowContext windowContext)
{
	while([windowContext.cocoaWindow isVisible])
	{
		[windowContext.renderDelegate setMetalTexture: windowContext.framebuffer];
		NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantFuture] inMode: NSDefaultRunLoopMode dequeue: YES];
	
		if(event != nil)
			[NSApp sendEvent: event];	
	}
}

#endif


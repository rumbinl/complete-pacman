#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>

int main()
{
	//id<MTLDevice> device = MTLCreateSystemDefaultDevice();

	NSRect contentRect = NSMakeRect(0, 480, 640, 480);
	NSWindowStyleMask styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable;
	NSBackingStoreType backingStoreType = NSBackingStoreBuffered;

	NSWindow* window = [[NSWindow alloc]initWithContentRect:contentRect styleMask: styleMask backing: backingStoreType defer: true];
	[[window contentView]initWithFrame: contentRect];

	[window setBackgroundColor: [NSColor colorWithSRGBRed:1.0 green: 0.5 blue: 0.25 alpha: 0.9]];

	[window makeKeyAndOrderFront: NSApp];
	[NSApp run];
	
	return 0;
}

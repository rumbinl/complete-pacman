#ifndef __PM_WINDOWCONTEXT__
#define __PM_WINDOWCONTEXT__


#ifdef __APPLE__
#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <MetalKit/MetalKit.h>
#include <mac/PM_MetalRenderer.h>
#endif

#include <image/PM_Image.h>
#define PM_FRAMEBUFFER_WIDTH 224
#define PM_FRAMEBUFFER_HEIGHT 248

typedef struct 
{
#ifdef __APPLE__
	NSWindow* cocoaWindow;
	MTKView* metalView;
	PM_MetalRenderer* renderDelegate;
#endif

	PM_Image32 framebuffer;

} PM_WindowContext;

PM_WindowContext PM_CreateWindowContext(unsigned int windowWidth, unsigned int windowHeight);

void PM_RunLoop(PM_WindowContext windowContext);

#endif

#ifndef __PM_METALWINDOW__
#define __PM_METALWINDOW__

#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <MetalKit/MetalKit.h>
#include <window/PM_WindowContext.h>
#include <mac/PM_MetalRenderer.h>

typedef struct 
{

	NSWindow* cocoaWindow;
	MTKView* metalView;
	PM_MetalRenderer* renderDelegate;

} PM_MetalWindowState;

PM_MetalWindowState PM_CreateMetalWindow(unsigned int windowWidth, unsigned int windowHeight);

void PM_RunMetalLoop(PM_WindowContext windowContext);

#endif

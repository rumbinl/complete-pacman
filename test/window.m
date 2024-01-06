#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

#include <window/PM_WindowContext.h>
#include <mac/PM_MetalTexture.h>

int main()
{
	PM_WindowContext windowContext = PM_CreateWindowContext(640, 480);

	PM_RunLoop(windowContext);

	return 0;
}

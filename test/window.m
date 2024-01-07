#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

#include <window/PM_WindowContext.h>

int main()
{
	PM_WindowContext windowContext = PM_CreateWindowContext(640, 480);

	PM_SetupWindowSprites(&windowContext);

	PM_RunLoop(windowContext);

	return 0;
}

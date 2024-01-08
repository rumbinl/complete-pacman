#include <window/PM_WindowContext.h>
#include <mac/PM_MetalWindow.h>

PM_WindowContext PM_CreateWindowContext(unsigned int windowWidth, unsigned int windowHeight)
{
	PM_WindowContext windowContext;
	
	PM_SetupWindowSprites(&windowContext);

	windowContext.metalWindowState = malloc(sizeof(PM_MetalWindowState)); 
	*(PM_MetalWindowState*)windowContext.metalWindowState = PM_CreateMetalWindow(windowWidth, windowHeight);
	
	return windowContext;
}

void PM_RunLoop(PM_WindowContext windowContext)
{
	PM_RunMetalLoop(windowContext);
}

#pragma once

#include <MetalKit/MetalKit.h>
#include <mac/PM_MetalTexture.h>

@interface PM_MetalRenderer : NSObject<MTKViewDelegate>

-(nonnull instancetype) initWithMTKView:(nonnull MTKView*) view;

@end



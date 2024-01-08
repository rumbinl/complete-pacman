#ifndef __PM_METALRENDERER__
#define __PM_METALRENDERER__

#include <MetalKit/MetalKit.h>
#include <image/PM_Image.h>

@interface PM_MetalRenderer : NSObject<MTKViewDelegate>

-(nonnull instancetype) initWithMTKView:(nonnull MTKView*) view;

-(id<MTLTexture> _Nullable) getMainMetalTexture;

-(void) setMetalTexture: (PM_Image32) image;

@end

#endif

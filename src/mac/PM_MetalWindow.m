#include <mac/PM_MetalWindow.h>

@implementation PM_MetalRenderer 
{
	id<MTLDevice> metalDevice;
	id<MTLCommandQueue> metalCommandQueue;
	id<MTLRenderPipelineState> metalPipelineState;
	id<MTLTexture> mainMetalTexture;
}

-(nonnull instancetype) initWithMTKView:(nonnull MTKView*) view
{
	self = [super init];

	metalDevice = MTLCreateSystemDefaultDevice();
	metalCommandQueue = [metalDevice newCommandQueue];

	MTLCompileOptions* metalCompileOptions = [[MTLCompileOptions alloc] init];

	NSError* error;
	NSString* shaderSource = [[NSString alloc] initWithContentsOfFile:@"./shaders.metal" encoding: NSUTF8StringEncoding error: &error];

	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);

	id<MTLLibrary> metalLibrary = [metalDevice newLibraryWithSource: shaderSource options: metalCompileOptions error:&error];

	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);

	id<MTLFunction> vertexFunction = [metalLibrary newFunctionWithName:@"vertexShader"];
	id<MTLFunction> fragmentFunction = [metalLibrary newFunctionWithName:@"fragmentShader"];

	MTLRenderPipelineDescriptor* pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
	pipelineDescriptor.label = @"pipeline";
	pipelineDescriptor.vertexFunction = vertexFunction;
	pipelineDescriptor.fragmentFunction = fragmentFunction;
	pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat;
	
	metalPipelineState = [metalDevice newRenderPipelineStateWithDescriptor: pipelineDescriptor error: &error];

	if(error != nil)
		NSLog(@"%@",[error localizedDescription]);

	return self;
}

-(void) drawInMTKView:(nonnull MTKView*) view
{
}

-(void) mtkView:(nonnull MTKView*) view drawableSizeWillChange:(CGSize) size
{
}

@end

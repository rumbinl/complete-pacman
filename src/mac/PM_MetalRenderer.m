#include <mac/PM_MetalRenderer.h>

float quadVertices[] = {
	-1, 1, 0.0f, 0.0f,
	-1, -1, 0.0f, 1.0f,
	1, 1, 1.0f, 0.0f,
	1, -1, 1.0f, 1.0f,
};

int quadIndices[] = {
	0, 1, 2,
	2, 1, 3
};

int viewportSize[] = {
	0,0
};

int texSize[] = {
	0, 0	
};

@implementation PM_MetalRenderer 
{
	id<MTLDevice> metalDevice;
	id<MTLCommandQueue> metalCommandQueue;
	id<MTLRenderPipelineState> metalPipelineState;
	id<MTLTexture> mainMetalTexture;
}

-(id<MTLTexture> _Nullable) getMainMetalTexture
{
	return mainMetalTexture;
}

-(nonnull instancetype) initWithMTKView:(nonnull MTKView*) view
{
	self = [super init];

	metalDevice = view.device;
	metalCommandQueue = [metalDevice newCommandQueue];

	MTLCompileOptions* metalCompileOptions = [[MTLCompileOptions alloc] init];

	NSError* error;
	NSString* shaderSource = [[NSString alloc] initWithContentsOfFile:@"shaders/shaders.metal" encoding: NSUTF8StringEncoding error: &error];

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
	@autoreleasepool {

		MTLRenderPassDescriptor* renderPass = view.currentRenderPassDescriptor;
		id<CAMetalDrawable> drawable = ((CAMetalLayer*)view.currentDrawable.layer).nextDrawable;

		renderPass.colorAttachments[0].texture = drawable.texture;
		renderPass.colorAttachments[0].loadAction = MTLLoadActionClear;
		renderPass.colorAttachments[0].storeAction = MTLStoreActionStore;

		id<MTLCommandBuffer> commandBuffer = [metalCommandQueue commandBuffer];
		id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor: renderPass];

		viewportSize[0] = view.drawableSize.width;
		viewportSize[1] = view.drawableSize.height;

		texSize[0] = mainMetalTexture.width;
		texSize[1] = mainMetalTexture.height;

		[commandEncoder setViewport:(MTLViewport){0.0, 0.0, view.drawableSize.width, view.drawableSize.height, 0.0, 1.0}];
		[commandEncoder setRenderPipelineState: metalPipelineState];
		[commandEncoder setVertexBytes:quadVertices length:sizeof(quadVertices) atIndex:0];
		[commandEncoder setVertexBytes:quadIndices length:sizeof(quadIndices) atIndex:1];
		[commandEncoder setVertexBytes:viewportSize length:sizeof(viewportSize) atIndex:2];
		[commandEncoder setVertexBytes:texSize length:sizeof(texSize) atIndex:3];
		[commandEncoder setFragmentTexture: mainMetalTexture atIndex: 0];
		[commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
		[commandEncoder endEncoding];

		[commandBuffer presentDrawable: (id<MTLDrawable>) drawable];
		[commandBuffer commit];
	}
}

-(void) setMetalTexture: (PM_Image32) image
{
	if(mainMetalTexture == nil || mainMetalTexture.width != image.imageWidth || mainMetalTexture.height != image.imageHeight)
	{
		MTLTextureDescriptor* textureDescriptor = [[MTLTextureDescriptor alloc]init];

		textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
		textureDescriptor.width = image.imageWidth;
		textureDescriptor.height = image.imageHeight;

		mainMetalTexture = [metalDevice newTextureWithDescriptor: textureDescriptor];
	}
	
	MTLRegion metalTextureRegion = {{0,0,0},{image.imageWidth, image.imageHeight,1}};
	[mainMetalTexture replaceRegion: metalTextureRegion mipmapLevel: 0 withBytes: image.pixelArray bytesPerRow: 4 * image.imageWidth];
}

-(void) mtkView:(nonnull MTKView*) view drawableSizeWillChange:(CGSize) size
{
}

@end

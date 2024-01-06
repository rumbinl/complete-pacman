#include <mac/PM_MetalTexture.h>

id<MTLTexture> PM_CreateMetalTexture(int width, int height, id<MTLDevice> device)
{
	MTLTextureDescriptor* textureDescriptor = [[MTLTextureDescriptor alloc]init];

	textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
	textureDescriptor.width = width;
	textureDescriptor.height = height;

	id<MTLTexture> result = [device newTextureWithDescriptor: textureDescriptor];
	return result;
}

void PM_SetMetalTextureContents(id<MTLTexture> metalTexture, uint32_t* pixelArray, int width, int height)
{
	MTLRegion region = {0, 0, 0, width, height, 1};
	[metalTexture replaceRegion: region mipmapLevel:0 withBytes: pixelArray bytesPerRow: 4 * width];
}

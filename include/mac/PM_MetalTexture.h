#pragma once

#include <Metal/Metal.h>

id<MTLTexture> PM_CreateMetalTexture(int width, int height, id<MTLDevice> device);

void PM_SetMetalTextureContents(id<MTLTexture> metalTexture, uint32_t* pixelArray, int width, int height);

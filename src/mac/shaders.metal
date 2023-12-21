#include <metal_stdlib>

using namespace metal;

vertex float4 vertexShader(uint vertexID [[vertex_id]], constant float* vertices [[buffer(0)]], constant float2& viewportSizePointer [[buffer(1)]])
{
	return float4(vertices[2*vertexID]/(viewportSizePointer.x/2.0f), vertices[2*vertexID+1]/(viewportSizePointer.y/2.0f), 0, 1);
}

fragment float4 fragmentShader()
{
	return float4(0.0f, 1.0f, 0.0f, 1.0f);
}

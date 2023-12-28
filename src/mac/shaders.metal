#include <metal_stdlib>

using namespace metal;

struct T_Vertex 
{
	float4 position [[position]];
	float2 texCoord;
};

vertex T_Vertex vertexShader(uint vertexID [[vertex_id]], constant float* vertices [[buffer(0)]], constant int* indices [[buffer(1)]], constant float2& viewportSizePointer [[buffer(2)]])
{
	T_Vertex out;
	out.position = float4(vertices[4*indices[vertexID]]/(viewportSizePointer.x/2.0f), vertices[4*indices[vertexID]+1]/(viewportSizePointer.y/2.0f), 0, 1); 
	out.texCoord = float2(vertices[4*indices[vertexID]+2], vertices[4*indices[vertexID]+3]);
	return out;
}

fragment float4 samplingShader(T_Vertex in [[stage_in]], texture2d<half> colorTexture [[texture(0)]])
{
	constexpr sampler textureSampler = {mag_filter::linear, min_filter::linear};
	
	const half4 out =  colorTexture.sample(textureSampler, in.texCoord);
	return float4(out);
}

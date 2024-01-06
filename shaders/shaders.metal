#include <metal_stdlib>

using namespace metal;

struct T_Vertex 
{
	float4 position [[position]];
	float2 texCoord;
};

vertex T_Vertex vertexShader(uint vertexID [[vertex_id]], constant float* vertices [[buffer(0)]], constant int* indices [[buffer(1)]], constant int* viewportSize [[buffer(2)]], constant int* texSize)
{
	T_Vertex out;
	if(viewportSize[0]/viewportSize[1] > texSize[0]/texSize[1])
	{
		out.position = float4(vertices[4*indices[vertexID]] * ((float)texSize[0]*viewportSize[1])/((float)texSize[1]*(float)viewportSize[0]), vertices[4*indices[vertexID]+1], 0, 1); 
	}
	else
	{
		out.position = float4(vertices[4*indices[vertexID]], vertices[4*indices[vertexID]+1] * ((float)texSize[1]*viewportSize[0])/((float)texSize[0]*(float)viewportSize[1]), 0, 1); 
	}
	out.texCoord = float2(vertices[4*indices[vertexID]+2], vertices[4*indices[vertexID]+3]);
	return out;
}

fragment float4 fragmentShader(T_Vertex in [[stage_in]], texture2d<half> colorTexture [[texture(0)]])
{
	constexpr sampler textureSampler = {min_filter::linear, min_filter::linear};
	
	const half4 out =  colorTexture.sample(textureSampler, in.texCoord);
	return float4(out);
}

//
// FOnline default effect
// For primitives (light, mini-map, pip-boy maps, etc)
//

#include "IOStructures.inc"


// Vertex shader
AppToVsToPs_2DPrimitive VSSimple(AppToVsToPs_2DPrimitive input)
{
	// Just pass forward
	return input;
}


// Pixel shader
float4 PSSimple(AppToVsToPs_2DPrimitive input) : COLOR
{
	// Just pass forward
	//return input.Diffuse;
	// Just pass forward
	// жирные линии обзора и радиуса атаки
	if (input.Diffuse.r == 1.0 && input.Diffuse.g == 0.0 && input.Diffuse.b == 0.0)		// && input.Diffuse.a == 0.3137255162
	{
		input.Diffuse.a = 1.0;
		input.Diffuse.r = 1.0;
		input.Diffuse.g = 0.2;
		input.Diffuse.b = 0.2;
	}
	if (input.Diffuse.r == 0.0 && input.Diffuse.g == 1.0 && input.Diffuse.b == 0.0)
	{
		input.Diffuse.a = 1.0;
		input.Diffuse.r = 0.2;
		input.Diffuse.g = 1.0;
		input.Diffuse.b = 0.2;
	}
	if (input.Diffuse.r == 0.0 && input.Diffuse.g == 0.7294117647058824 && input.Diffuse.b == 1.0)
	{
		input.Diffuse.a = 1.0;
		input.Diffuse.r = 0.0;
		input.Diffuse.g = 0.0;
		input.Diffuse.b = 1.0;
	}

	   return input.Diffuse;
}


// Techniques
technique Simple
{
	pass p0
	{
		VertexShader = (compile vs_2_0 VSSimple());
		PixelShader  = (compile ps_2_0 PSSimple());
	}
}


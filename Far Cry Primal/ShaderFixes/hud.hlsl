#include <ShaderFixes/crosshair.hlsl>

bool is_minimap(float4 pos, float4 params1)
{
	return params1.x && pos.x < -0.4 && pos.y < -0.05;
}

bool is_subtitle(float4 pos)
{
	return pos.y < -0.7;
}

bool is_goals(float4 pos)
{
	return pos.x < 0.15 && pos.y > 0.2;
}

bool is_crosshair(float4 pos, float4 params1)
{
	return (params1.y == 2);
}

float adjust_hud(float4 pos)
{
	float4 stereo = StereoParams.Load(0);
	float4 params0 = IniParams.Load(0);
	float4 params1 = IniParams.Load(1);
	float width, height;

	ZBuffer.GetDimensions(width, height);
	if (!width)
		return stereo.x * params0.x;

	if (is_minimap(pos, params1))
		return stereo.x * params0.y;

	if (is_subtitle(pos))
		return stereo.x * params0.w;

	if (is_goals(pos))
		return stereo.x * params0.z - abs(stereo.x);

	if (is_crosshair(pos, params1))
		return adjust_from_stereo2mono_depth_buffer(0, 0);

	return stereo.x * params0.x;
}

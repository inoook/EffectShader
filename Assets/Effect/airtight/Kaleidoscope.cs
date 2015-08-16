using UnityEngine;
using System.Collections;

public class Kaleidoscope : EffectBase {

	public float sides = 6.0f;
	public float angle = 0.0f;
	
	protected override void InitShader()
	{
		shaderName = "Custom/KaleidoscopeImageEffect";
		base.InitShader();
	}
	
	protected override void UpdateParams()
	{
		material.SetFloat ("_sides", sides);
		material.SetFloat ("_angle", angle);
	}
	
}


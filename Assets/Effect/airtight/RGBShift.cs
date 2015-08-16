using UnityEngine;
using System.Collections;

public class RGBShift : EffectBase {

	public float amount = 0.005f;
	public float angle = 0.0f;

	protected override void InitShader()
	{
		shaderName = "Custom/RGBShift";
		base.InitShader();
	}

	protected override void UpdateParams()
	{
		material.SetFloat ("amount", amount);
		material.SetFloat ("angle", angle);
	}
}


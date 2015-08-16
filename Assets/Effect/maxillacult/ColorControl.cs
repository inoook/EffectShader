using UnityEngine;
using System.Collections;

public class ColorControl : EffectBase {

	public float riseR = 0.2f;
	public float riseG = 0.2f;
	public float riseB = 0.2f;

	protected override void InitShader()
	{
		shaderName = "Custom/ColorControl";
		base.InitShader();
	}

	protected override void UpdateParams()
	{
		material.SetFloat ("riseR", riseR);
		material.SetFloat ("riseG", riseG);
		material.SetFloat ("riseB", riseB);
	}
}


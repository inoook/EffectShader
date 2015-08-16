using UnityEngine;
using System.Collections;

public class Slitscan : EffectBase {
	
	public float val3 = 0.2f;
	
	protected override void InitShader()
	{
		shaderName = "Custom/Slitscan";
		base.InitShader();
	}
	
	protected override void UpdateParams()
	{
		material.SetFloat("val3", val3);
	}
}
